local S_tt = minetest.get_translator("tt_base")

--- @type table<string, projectiles.Registration>
local registered_projectiles = {}
local entity = require("projectiles.entity")

--- @class projectiles.Registration
--- @field projectile_texture table           table of textures used for projectile entity
--- @field definition         ItemDefinition  definition of projectile craftitem
--- @field entity_name        string          itemstring <mod>:<name>; used to name the projectile entity
--- @field damage             number          damage base value of projectile that used to calculate resulting damage
--- @field speed              number          projectile speed multiplier that used to calculate the flight trajectory
--- @field type               string          a type of projectile
--- @field damage_tt          number          damage value used in tooltip
--- @field entity_reg         projectiles.Entity.Definition entity registration table


--- @param name               string                    itemstring "<mod>:<projectile_name>"
--- @param reg                projectiles.Registration  projectile registration table
--- @param not_register_item  boolean                   whether to register craftitem or not (false/nil = register)
local function register_projectile(name, reg, not_register_item)
	local def       = reg.definition
	reg.type        = reg.type
	reg.entity_name = reg.entity_name or name

	registered_projectiles[name] = reg

	entity.register_projectile_entity(reg.entity_name, reg.entity_reg)

	if not_register_item then
		return
	end

	minetest.register_craftitem(name, table.overwrite({
		_tt_help = S_tt("Damage: @1", reg.damage_tt)
	}, def))
end

--- Flame air and replace some nodes with fire.
--- @param pos            Position   node position
--- @param in_nazgul_area boolean    flag that the node is in an area protected from explosions
local flame_node = function(pos, in_nazgul_area)
	local n = minetest.get_node(pos).name
	local node_desc = minetest.registered_nodes[n]
	if node_desc == nil then
		minetest.log("error", "Attempt to flame unknown node: "..n..
				" ("..pos.x..","..pos.y..","..pos.z..")")
		return
	end

	if node_desc.groups == nil then
		node_desc.groups = {}
	end

	if node_desc.groups.forbidden == nil then
		if node_desc.groups.flammable or math.random(1, 100) <= 30 then
			if n == "air" or not in_nazgul_area then
				minetest.set_node(pos, { name = "fire:basic_flame" })
			end
		else
			if not in_nazgul_area then
				-- one cannot simply remove a node without exploding it first
				if node_desc.on_blast then
					node_desc.on_blast(pos)
				end
				minetest.remove_node(pos)
			end
		end
	end
end

-- `explosive_object` is temporary workaround for mobs to be affected by the explosion
local explode_objects = function(pos, radius, explosive_object, damage_groups)
	for obj in core.objects_inside_radius(pos, radius) do
		if obj == explosive_object then
			goto continue
		end
		local obj_pos = obj:get_pos()
		local distance_vector = vector.subtract(obj_pos, pos)
		local distance_length = vector.length(distance_vector)
		local dir_vector = vector.normalize(distance_vector)
		local explosion_power

		if distance_length == 0 then
			explosion_power = radius
		else
			explosion_power = -math.log10((distance_length/radius)^2)
			if explosion_power > radius then
				explosion_power = radius
			end
		end
		local dealt_damage = table.mul_values(table.div_values(damage_groups, {}, radius), {}, explosion_power)
		obj:punch(explosive_object, 1.4, {
			full_punch_interval = 1.4,
			damage_groups       = dealt_damage
		}, vector.multiply(dir_vector, explosion_power))
		::continue::
	end
end

--- Invoke on_blast() callback in the node.
--- @param pos            Position   position of the node
--- @param in_nazgul_area boolean    flag that the node is in an area protected from explosions
local explode_node = function(pos, in_nazgul_area)
	local node = core.get_node(pos)
	local node_def = core.registered_nodes[node.name]

	if not in_nazgul_area then
		if node_def then
			if node_def.on_blast then
				node_def.on_blast(pos)
			else
				core.punch_node(pos)
			end
		end
	end
end

--- Deal damage and explode nodes in an area hit by an explosive projectile
--- @param pos              Position    position of the node hit by the projectile
--- @param burn_radius      number      radius in which nodes are hit and flames appear
--- @param explosion_radius number      radius in which entities are damaged
--- @param explosive_object ObjectRef   projectile object
--- @param damage_groups    table       damage groups table
local explode_area = function(pos, burn_radius, explosion_radius, explosive_object, damage_groups)
	local rad_vec = vector.new(burn_radius, burn_radius, burn_radius)
	local p1 = vector.subtract(pos, rad_vec)
	local p2 = vector.add(pos, rad_vec)

	local node_pos
	local in_nazgul_area

	explode_objects(pos, explosion_radius, explosive_object, damage_groups)

	for x = p1.x, p2.x do
		for y = p1.y, p2.y do
			for z = p1.z, p2.z do
				node_pos = { x = x, y = y, z = z }
				in_nazgul_area = nazgul_area.position_in_nazgul_area(node_pos)

				explode_node(node_pos, in_nazgul_area)
				flame_node(node_pos, in_nazgul_area)
			end
		end
	end
end


return {
	explode_area         = explode_area,
	register_projectile  = register_projectile,
	get_rotation_pattern = entity.get_rotation_pattern,
	--- @return table<string, projectiles.Registration>
	get_projectiles      = function() return registered_projectiles end,
	--- @param name string|nil technical item name (`"<mod>:<projectile_name>"`) or `nil` to return full list.
	get                  = function(name)
		return name
			and (registered_projectiles[name] or nil)
			or  registered_projectiles
	end,
}
