local FlowControl = require('exception.FlowControl')


--- @class Voxrame.exception
local exception = {}

--- Try/catch on top of `xpcall()`.
--- Calls `callback()` immediately in the protected mode.
--- Errors are NOT rethrown: without `:catch()` they are silently swallowed.
---
--- Example:
--- ```lua
--- local try = Voxrame.exception.try
---
--- try(function()
---     risky()
--- end):catch(function(error, traceback)
---     -- in production: to the log, plain text (without styles and links)
---     core.log('error', tostring(error) .. '\n' .. debug.render_backtrace(traceback, true))
---     -- in development: to the terminal, with highlighting and links
---     debug.print_backtrace(traceback)
--- end)
--- ```
--- @param callback fun() function to call in the protected mode
--- @return Voxrame.exception.FlowControl
function exception.try(callback)
	return FlowControl:try(callback)
end


return exception
