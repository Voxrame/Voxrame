
--- @class Voxrame.mod.Translator
local Translator = {}

--- @static
--- @overload fun():fun(str: string, ...):string
--- @param mod_name string|nil
--- @return fun(str: string, ...):string
function Translator.get(mod_name)
	return core.get_translator(mod_name or core.get_current_modname())
end


return Translator
