local setmetatable, xpcall
    = setmetatable, xpcall


--- Information about an error, collected by `FlowControl.on_error()`.
--- @class Voxrame.exception.ErrorInfo
--- @field error     any
--- @field traceback debuglib.StackFrame[]

--- Calls the function in the protected mode and allows to handle an error: `:catch()`.
--- @class Voxrame.exception.FlowControl
local FlowControl = {
	--- `true` if the function finished without an error.
	--- @private
	--- @type boolean
	ok        = false,
	--- error object (when not `ok`).
	--- @private
	--- @type any?
	error     = nil,
	--- call stack at the moment of the error (when not `ok`), innermost first.
	--- @private
	--- @type debuglib.StackFrame[]?
	traceback = nil,
}

--- @private
--- @param ok         boolean
--- @param error?     any
--- @param traceback? debuglib.StackFrame[]
--- @return Voxrame.exception.FlowControl
function FlowControl:new(ok, error, traceback)
	local class = self

	self = {}
	self.ok        = ok
	self.error     = error
	self.traceback = traceback

	return setmetatable(self, { __index = class })
end

--- Result of a call without an error is always the same, so it's shared between all successful calls.
--- For optimization, we don't create a new object for each successful call.
--- @static
--- @private
--- @type Voxrame.exception.FlowControl
FlowControl.SUCCESS = FlowControl:new(true)

--- Handler for `xpcall()`: collects error info at the moment of the error, until the stack is unwound.
--- @static
--- @private
--- @param original_error any
--- @return Voxrame.exception.ErrorInfo
function FlowControl.on_error(original_error)
	-- depth 1: skip `on_error` itself, start from the function where the error occurred
	return { error = original_error, traceback = debug.get_stack_frames(1) }
end

--- Calls `callback()` immediately in the protected mode. Errors are NOT rethrown: handle them with `:catch()`.
--- @param callback fun() function to call in the protected mode
--- @return Voxrame.exception.FlowControl
function FlowControl:try(callback)
	local ok, result = xpcall(callback, self.on_error)

	if ok then
		return self.SUCCESS
	end
	--- @cast result Voxrame.exception.ErrorInfo since not `ok`, so `result` is what `on_error()` returned

	return self:new(false, result.error, result.traceback)
end

--- Calls `handler(error, traceback)` if the protected function has failed. Does nothing otherwise.
--- @param handler fun(error: any, traceback: debuglib.StackFrame[])
--- @return Voxrame.exception.FlowControl self for chaining
function FlowControl:catch(handler)
	if not self.ok then
		--- @cast self.traceback debuglib.StackFrame[] since `traceback` is always set when `ok` is `false`
		handler(self.error, self.traceback)
	end

	return self
end


return FlowControl
