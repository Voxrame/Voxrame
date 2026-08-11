local math_floor, type, tonumber, string_format, print
    = math.floor, type, tonumber, string.format, print


term = {}

--- ANSI escape codes of terminal styles.
term.style = {
	-- Reset
	reset                   = '\27[0m',
	-- Basic colors
	black                   = '\27[30m',
	red                     = '\27[31m',
	green                   = '\27[32m',
	yellow                  = '\27[33m',
	blue                    = '\27[34m',
	magenta                 = '\27[35m',
	cyan                    = '\27[36m',
	white                   = '\27[37m',
	-- Bright colors
	bright_black            = '\27[90m',
	bright_red              = '\27[91m',
	bright_green            = '\27[92m',
	bright_yellow           = '\27[93m',
	bright_blue             = '\27[94m',
	bright_magenta          = '\27[95m',
	bright_cyan             = '\27[96m',
	bright_white            = '\27[97m',
	-- Background colors
	bg_black                = '\27[40m',
	bg_red                  = '\27[41m',
	bg_green                = '\27[42m',
	bg_yellow               = '\27[43m',
	bg_blue                 = '\27[44m',
	bg_magenta              = '\27[45m',
	bg_cyan                 = '\27[46m',
	bg_white                = '\27[47m',
	-- Bright background colors
	bg_bright_black         = '\27[100m',
	bg_bright_red           = '\27[101m',
	bg_bright_green         = '\27[102m',
	bg_bright_yellow        = '\27[103m',
	bg_bright_blue          = '\27[104m',
	bg_bright_magenta       = '\27[105m',
	bg_bright_cyan          = '\27[106m',
	bg_bright_white         = '\27[107m',
	-- Text styles
	bold                    = '\27[1m',
	dim                     = '\27[2m',
	italic                  = '\27[3m',
	underline               = '\27[4m',
	blink                   = '\27[5m',
	reverse                 = '\27[7m', -- Reverse video (swap foreground and background)
	hidden                  = '\27[8m', -- Hidden text
	strikethrough           = '\27[9m',
	-- Underlines (SGR 4:x)
	underline_solid         = '\27[4:1m',
	underline_double        = '\27[4:2m',
	underline_curly         = '\27[4:3m',
	underline_dotted        = '\27[4:4m',
	underline_dashed        = '\27[4:5m',
	-- Underline colors (SGR 58)
	underline_color_black   = '\27[58;5;0m',
	underline_color_red     = '\27[58;5;1m',
	underline_color_green   = '\27[58;5;2m',
	underline_color_yellow  = '\27[58;5;3m',
	underline_color_blue    = '\27[58;5;4m',
	underline_color_magenta = '\27[58;5;5m',
	underline_color_cyan    = '\27[58;5;6m',
	underline_color_white   = '\27[58;5;7m',
	-- Reset specific attributes
	reset_bold              = '\27[22m',
	reset_dim               = '\27[22m',
	reset_italic            = '\27[23m',
	reset_underline         = '\27[24m',
	reset_blink             = '\27[25m',
	reset_reverse           = '\27[27m',
	reset_hidden            = '\27[28m',
	reset_strikethrough     = '\27[29m',
	reset_underline_color   = '\27[59m',
}

--- @type boolean
term.supports_ansi = (function()
	-- Unix-like
	if os.getenv('TERM') and os.getenv('TERM') ~= 'dumb' then
		return true
	end
	-- Windows 10+ (PowerShell, Terminal, ConEmu)
	if os.getenv('ANSICON') or os.getenv('WT_SESSION') then
		return true
	end
	-- Additional check via Windows Registry
	-- Luanti does not provide `io.popen` without `core.request_insecure_environment()`.
	--   We does not requests ie, but check availability (in case if in future it will be avaible).
	if os.getenv('OS') == 'Windows_NT' and io.popen then
		local handle = io.popen('reg query HKCU\\Console /v VirtualTerminalLevel 2>nul')
		local result = handle:read('*a')
		handle:close()

		return result:find('0x1') ~= nil
	end

	return false
end) ()

--- @type boolean
term.supports_truecolor = (function()
	local colorterm = os.getenv('COLORTERM') or ''
	if colorterm == 'truecolor' or colorterm == '24bit' then
		return true
	end

	-- Windows Terminal (always supports TrueColor)
	if os.getenv('WT_SESSION') then
		return true
	end

	local term_env = os.getenv('TERM') or ''
	-- Known terminals that definitely support TrueColor, but may not have the variable
	if term_env:find('kitty') or term_env:find('iterm') or term_env:find('wezterm') then
		return true
	end
	if os.getenv('TERMINAL_EMULATOR') == 'JetBrains-JediTerm' then
		return true
	end

	return false
end) ()

--- We just use the same value as `term.supports_ansi`.  \
--- It no reason to detect it, because most terminals support it & much more terminals will implement it soon.
---
--- - for separate scripts:\
---   you can override this value, if your terminal doesn't support OSC 8.
--- - for use for debug prints inside the game:\
---   set `debug.terminal.supports_osc8` to `false` in minetest.conf
---
--- @see https://github.com/Alhadis/OSC8-Adoption/
--- @type boolean
term.supports_osc8 = term.supports_ansi


--- Converts RGB color to 256-color palette index.
--- @param r integer Red component (0-255)
--- @param g integer Green component (0-255)
--- @param b integer Blue component (0-255)
--- @return integer 256-color palette index (0-255)
local function rgb_to_256(r, g, b)
    return 16 + (math_floor(r / 51) * 36) + (math_floor(g / 51) * 6) + math_floor(b / 51)
end

--- Generates ANSI code for any type of color.  \
--- **Note:** This function doesn't check if terminal supports ANSI.
--- @param mode    'text'|'bg'|'under'  Type of coloring.
--- @param id_or_hex_or_r integer|string Color ID (0-255) OR Hex color (e.g. "#FF0000") OR Red component (0-255).
--- @param g?      integer               Green component (0-255).
--- @param b?      integer               Blue component (0-255).
--- @return string
function term.color(mode, id_or_hex_or_r, g, b)
	local map = { text = 38, bg = 48, under = 58 }
	local code = map[mode] or 38

	--- @type integer
	local r
	if type(id_or_hex_or_r) == 'string' and id_or_hex_or_r:match('^#%x%x%x%x%x%x$') then
		local h = id_or_hex_or_r:gsub('#', '')
		r = tonumber(h:sub(1, 2), 16) --- @as integer we previously checked that it's a hex
		g = tonumber(h:sub(3, 4), 16)
		b = tonumber(h:sub(5, 6), 16)
	else --- @cast id_or_hex_or_r integer
		r = id_or_hex_or_r
	end

	return (g and b)
		-- TrueColor (24-bit RGB): ESC[X;2;R;G;Bm
		and (term.supports_truecolor
			and string_format('\27[%d;2;%d;%d;%dm', code, r, g, b)       -- TrueColor ESC[X;2;R;G;Bm
			or  string_format('\27[%d;5;%dm', code, rgb_to_256(r, g, b)) -- 256-color ESC[X;5;IDm
		)
		-- 256 Colors (ID): ESC[X;5;IDm
		or  string_format('\27[%d;5;%dm', code, id_or_hex_or_r)
end

--- Returns styled text if terminal supports ANSI, otherwise returns text without style.
--- @overload fun(text:string)
--- @param text   string|number|integer Text to stylize.
--- @param style  string Color or style ANSI-code. (one of `term.style`). You can concatenate several styles.
--- @param reset? string ANSI-code to reset style, default is `term.style.reset`
--- @return string
function term.stylize(text, style, reset)
	reset = reset or term.style.reset

	--- @cast text string
	return (term.supports_ansi and style)
		and (style .. text .. reset)
		or  text
end

--- Prints text with specified style.
--- @overload fun(text:string)
--- @param text  string Text to print.
--- @param style string Color or style ANSI-code. (one of `term.style`). You can concatenate several styles.
function term.print(text, style)
	print(term.stylize(text, style))
end

--- Returns ANSI OSC 8 clickable link for terminal that support ANSI.
---
--- Otherwise or if `url` not passed or empty string, returns text without link.
---
--- @overload fun(text:string)
--- @param text   string Text to make clickable.
--- @param url?   string URL to open when clicked.
--- @param style? string Style to apply to the link. Default is `term.default.link_style`
--- @param reset? string ANSI-code to reset style. Default is `term.default.link_reset`
--- @return string
function term.link(text, url, style, reset)
	if (not term.supports_ansi or not url or url == '') then
		return text
	end

	style = style or term.default.link_style
	reset = reset or term.default.link_reset

	local full_reset = term.style.reset
	text = text:replace(full_reset:reg_escape(), full_reset .. style)
	text = term.stylize(text, style, reset)

	return '\27]8;;' .. url .. '\27\\' .. text .. '\27]8;;\27\\'
end

term.default = {
	link_style = term.style.underline_dotted .. term.color('under', '#fc009b'),
	link_reset = term.style.reset_underline_color .. term.style.reset_underline,
}
