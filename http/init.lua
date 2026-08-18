
local http_api = core.request_http_api()
if not http_api then
	core.log(
		"error",
		"[http] You should add mod `http` into `secure.http_mods` setting in your `minetest.conf`.")
	return
end

core.mod(function(mod)
	require("http").init(http_api)
end)
