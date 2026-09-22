local debug_getinfo, term
    = debug.getinfo, Voxrame.terminal


local PROJECT_LOCATION = ''

local debug_mode   = core.settings:get_bool('debug', false)
local x_scheme_tpl = debug_mode	and core.settings:get('debug.editor_x_scheme_tpl') or  nil

term.supports_osc8 = core.settings:get_bool('debug.terminal.supports_osc8', term.supports_osc8)

--- @param file_full string
--- @param line      integer
--- @return string
local function get_x_scheme_url(file_full, line)
	local file_relative = file_full:replace(PROJECT_LOCATION:reg_escape(), '')

	return (x_scheme_tpl or '')
		:replace('%${file}', file_full)
		:replace('%${file_relative}', file_relative)
		:replace('%${line}', line)
		:replace('%${project}', PROJECT_LOCATION)
end

--- @param file_full string
--- @param line      integer
--- @return string
local function get_file_line_term_string(file_full, line)
	local file = file_full:replace(PROJECT_LOCATION:reg_escape(), '')

	local file_line_styled = ''
		.. term.stylize('@ ', term.style.bright_yellow)
		.. term.stylize(file, term.style.yellow)
		.. term.stylize(':', term.style.bright_white)
		.. term.stylize(line, term.style.green)

	return x_scheme_tpl
		and term.link(file_line_styled, get_x_scheme_url(file_full, line))
		or  file_line_styled
end

--- @param depth? integer Call stack nesting level (default: `0`)
--- @param full?  boolean get full path; default: `false`
--- @return string
function __FILE__(depth, full) -- luacheck: ignore unused global variable __FILE__
	full = full or false
	--- @diagnostic disable-next-line: need-check-nil
	local full_file = debug_getinfo(2 + (depth or 0), 'S').source:replace('^@', '')

	return full
		and full_file
		or  full_file:replace(PROJECT_LOCATION:reg_escape(), '')
end

--- @param depth? integer Call stack nesting level (default: `0`)
--- @return integer
function __LINE__(depth) -- luacheck: ignore unused global variable __LINE__
	return debug_getinfo(2 + (depth or 0), 'l').currentline --- @diagnostic disable-line: need-check-nil
end

--- @param depth? integer Call stack nesting level (default: `0`)
--- @param full?  boolean get full path; default: `false`
--- @return string
function __FILE_LINE__(depth, full) -- luacheck: ignore unused global variable __FILE_LINE__
	depth = depth or 0
	return __FILE__(depth + 1, full) .. ':' .. __LINE__(depth + 1)
end

--- @param depth? integer Call stack nesting level (default: `0`)
--- @return string
function __FUNC__(depth)  -- luacheck: ignore unused global variable __FUNC__
	return debug_getinfo(2 + (depth or 0), 'n').name --- @diagnostic disable-line: need-check-nil
end

--- @param depth? integer Call stack nesting level (default: `0`)
--- @return string
function __DIR__(depth)
	local file_path = __FILE__(1 + (depth or 0))
	local dir_path  = file_path:match('(.*[/\\])') or './'

	return dir_path
end


local up = io.dirname
PROJECT_LOCATION = up(up(up(up(up(up(__DIR__())))))) .. os.DIRECTORY_SEPARATOR


--- @param line_code string
--- @return table, integer  # array of passed params & max string length of param
function debug.get_passed_params(line_code)
	local params_str = (line_code:match('%b()') or '')
		:sub(2, -2):gsub('%s+', '')

	local params           = {}
	local buffer           = ''
	local bracket_depth    = 0
	local max_param_length = 0
	for i = 1, #params_str do
		local char = params_str:sub(i, i)

		if char == '(' then
			bracket_depth = bracket_depth + 1
			buffer        = buffer .. char
		elseif char == ')' then
			bracket_depth = bracket_depth - 1
			buffer        = buffer .. char
		elseif char == ',' and bracket_depth == 0 then
			table.insert(params, buffer:trim())
			max_param_length = #buffer > max_param_length and #buffer or max_param_length
			buffer = ''
		else
			buffer = buffer .. char
		end
	end

	if buffer ~= '' then
		table.insert(params, buffer:trim())
	end

	return params, max_param_length
end

--- @param file      string
--- @param line_from integer 1-based line number
--- @param line_to?  integer default: `line_from`
--- @return string
function debug.get_file_code(file, line_from, line_to)
	line_to = line_to or line_from

	local code = {}
	local current_line = 0
	for line in io.lines(file) do
		current_line = current_line + 1
		if current_line >  line_to   then  break                    end
		if current_line >= line_from then  table.insert(code, line) end
	end

	return table.concat(code, '\n')
end

--- @param func function
--- @return string
function debug.get_function_code(func)
	local func_info = debug_getinfo(func) --- @as debuglib.DebugInfo
	local name = func_info.source:replace('^@','')

	return debug.get_file_code(name, func_info.linedefined, func_info.lastlinedefined) or ''
end

--- One frame of the call stack.
--- @class debuglib.StackFrame
--- @field file  string  source file of the function (`=[C]` for functions written in C).
--- @field line  integer current line in the file (`-1` for functions written in C).
--- @field name  string? name of the function, if known.
--- @field what  string  `Lua`, `C`, `main` or `tail`.

--- Returns frames of the call stack, from the innermost to the outermost.
--- @param depth? integer Call stack nesting level to start from; `0` (default) - the caller of this function.
--- @return debuglib.StackFrame[]
function debug.get_stack_frames(depth)
	local frames = {}

	-- level 1 is this function itself
	for level = 2 + (depth or 0), math.huge do
		local info = debug_getinfo(level, 'Sln')
		if not info then
			break
		end

		frames[#frames + 1] = {
			file = info.source:replace('^@', ''),
			line = info.currentline,
			name = info.name,
			what = info.what,
		}
	end

	return frames
end

--- Renders frames of the call stack as a multi-line string (one line per frame).
---
--- By default the string is styled for a terminal. If your terminal supports links, every `@ <file>:<line>` will
--- linked to open IDE, see `readme.md` to configure.
--- Pass `plain = true` to get a string without any styles and links, e.g. to write to a log in production.
---
--- @param frames debuglib.StackFrame[] see `debug.get_stack_frames()`
--- @param plain? boolean               render without styles & links; default: `false`
--- @return string
function debug.render_backtrace(frames, plain)
	local trace = ''
	for i, frame in ipairs(frames) do
		if plain then
			local location = frame.what == 'C'
				and '@ [C]'
				or  ('@ %s:%d'):format(frame.file:replace(PROJECT_LOCATION:reg_escape(), ''), frame.line)

			trace = trace .. ('%4s   %s: in %s\n'):format(i, location, frame.name or frame.what)
		else
			trace = trace
				.. term.stylize(('%4s   '):format(i), term.style.italic .. term.style.dim)
				.. (frame.what == 'C'
					and term.stylize('@', term.style.bright_yellow) .. ' [C]'
					or  get_file_line_term_string(frame.file, frame.line)
				)
				.. term.stylize(': in ' .. (frame.name or frame.what), term.style.cyan)
				.. '\n'
		end
	end

	return trace
end

--- Prints frames of the call stack to the terminal (styled, with links). For a quick look while debugging.
--- Shorten for `term.print(debug.render_backtrace(frames))`.
--- For production (e.g. to write to a log) use `debug.render_backtrace(frames, true)`.
---
--- @param frames debuglib.StackFrame[] see `debug.get_stack_frames()`
function debug.print_backtrace(frames)
	term.print(debug.render_backtrace(frames))
end

--- Dumps all passed params, also show `@ <file>:<line>` where `pdt()` was called.
---
--- If `with_trace` is `true` additionally prints stack trace from place of call.
---
--- If your terminal supports links, every `@ <file>:<line>` will linked to open IDE, see `readme.md` to configure.
---
--- @param depth?      integer call stack depth to start from
--- @param with_trace? boolean print trace or not
--- @param ...         any     params to dump
function print_dump(depth, with_trace, ...)
	depth = depth or 0
	local file_full = __FILE__(1 + depth, true)
	local line      = __LINE__(1 + depth)

	term.print(get_file_line_term_string(file_full, line))
	if with_trace then
		term.print(debug.render_backtrace(debug.get_stack_frames(2 + depth)))
	end

	local passed_params, max_param_length = debug.get_passed_params(debug.get_file_code(file_full, line))
	max_param_length = max_param_length

	for i = 1, select('#', ...) do
		local name = passed_params[i] or ('<' .. i .. '>')
		name = (' '):rep(max_param_length - #name) .. name
		local value = select(i, ...)
		print(term.stylize(name .. ':', term.style.cyan) .. ' ' .. (
			type(value) == 'function'
				and debug.get_function_code(value)
				or  dump(value)
		))
	end
end

--- Dumps all passed params, also show `@ <file>:<line>` & stack trace where `pd()` was called.
--- Shorten for `print_dump(0, true, ...)`.
--- See `readme.md` to configure your IDE to open `<file>:<line>` links from terminal.
--- @param ... any
function pdt(...) -- luacheck: ignore unused global variable pdt
	print_dump(1, true, ...)
end

--- Dumps all passed params, also show `@ <file>:<line>` where `pd()` was called.
--- Shorten for `print_dump(0, false, ...)`.
--- See `readme.md` to configure your IDE to open `<file>:<line>` links from terminal.
--- @param ... any
function pd(...) -- luacheck: ignore unused global variable pd
	print_dump(1, false, ...)
end


local original_error_handler = core.error_handler
---@overload fun(message:string)
---@param message string
---@param depth integer
function core.error_handler(message, depth)
	depth   = depth or 0
	message = message or term.stylize('~ no error message ~', term.style.italic .. term.style.red)
	message = message:gsub('%.%.%.[^:]+:[0-9]+: ', '')

	if debug_mode then
		term.print(('+'):rep(80), term.style.green)
		term.print('ERROR:', term.style.bold .. term.style.bright_red)
		term.print('  ' .. message, term.style.bright_red)
		term.print('')
		term.print('Stack trace:', term.style.bold .. term.style.bright_red)
		term.print(debug.render_backtrace(debug.get_stack_frames(depth)))
		term.print(('+'):rep(80), term.style.green)

		return 'Debug mode is `on`. See you terminal.'
	else
		return original_error_handler(message, depth)
	end
end

--- @type { [string]: number }
local measure_average = {}
--- @type { [string]: number }
local measure_count   = {}
--- @type { [string]: number }
local measure_last    = {}

--- Measures time and average time of `callback` function execution.  \
--- Prints result if `print_result` is `true`.
---
--- @param name          string  ununique name of mesure
--- @param callback      fun()   function to mesure time of
--- @param print_result? boolean whether to print result
---
--- @return number, number, number, string?  # time, average time, count of mesures, print string if not `print_result`
function debug.measure(name, callback, print_result)
	local start = os.clock()
	if not measure_average[name] then
		measure_average[name] = 0
		measure_count  [name] = 0
	end

	callback()

	local time = (os.clock() - start) * 1000

	measure_average[name] = (measure_average[name] * measure_count[name] + time) / (measure_count[name] + 1)
	measure_count  [name] = measure_count[name] + 1
	measure_last   [name] = time

	-- Align results to make them one under another
	local print_string = ('Measure of [%s]:  Time: %5.0f ms ;  Average: %5.0f ms')
		:format(name, time, measure_average[name])

	if print_result then
		print(print_string)

		return time, measure_average[name], measure_count[name]
	end

	return time, measure_average[name], measure_count[name], print_string
end

--- Prints results of previous `debug.mesure()`
---
--- @param name string ununique name of mesure
function debug.mesure_print(name)
	if not measure_average[name] then
		print('Measure of [' .. name .. ']:  No mesure found')

		return
	end

	print(
		('Measure of [%s]: Average time: %5.0f ms ; Last time: %5.0f ms ; Count of mesures: %5.0f')
			:format(name, measure_average[name], measure_last[name], measure_count[name])
	)
end
