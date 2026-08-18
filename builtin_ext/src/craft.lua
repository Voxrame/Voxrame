require("craft.method")
require("craft.recipe")


--- @param grid string[][]
--- @return string[][]
local function mirrored_grid(grid)
	local mirrored = {}
	for i, row in ipairs(grid) do
		mirrored[i] = {}
		local row_length = #row
		for j, item in ipairs(row) do
			mirrored[i][row_length - j +1] = item
		end
	end

	return mirrored
end

--- @param recipe core.CraftRecipe
function core.register_mirrored_crafts(recipe)
	--- @type core.CraftRecipe
	local mirrored = table.copy(recipe)
	mirrored.recipe = mirrored_grid(mirrored.recipe)

	core.register_craft(recipe)
	core.register_craft(mirrored)
end
