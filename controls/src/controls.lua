local api = require("controls.api")


controls = api

local function register_api()
	controls = api
end


return {
	init = function()
		register_api()
	end,
}
