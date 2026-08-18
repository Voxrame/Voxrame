GRAVITY = core.settings:get("movement_gravity") or 9.81

core.mod(function(mod)
	require("projectiles").init()
end)
