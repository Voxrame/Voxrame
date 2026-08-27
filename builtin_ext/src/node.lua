local v = vector.new

--- Swaps node if node is not same and return old node name.
--- @see core.swap_node
---
--- @private
--- @param position  Position position of node
--- @param node_name string   technical node name (`"<mod>:<name>"`, for ex. `"default:dirt"`)
--- @return string old node name.
function core.swap_node_if_not_same(position, node_name)
	local node = core.get_node(position)
	if node.name ~= node_name then
		node.name = node_name
		core.swap_node(position, node)
	end

	return node.name
end

--- Finds nodes near position.
---
--- @param position         MapPosition  Center position to search around.
--- @param radius           number       Search radius.
--- @param node_names       table|string Nodes to search. (e.g. `{"ignore", "group:tree"}` or `"default:dirt"`)
--- @param search_in_center boolean      Optional. If true `pos` is also checked for the nodes. (default: `false`).
---
--- @return table<Position,NodeTable> Found nodes.
function core.find_nodes_near(position, radius, node_names, search_in_center)
	local pos1 = v(position):subtract(radius) --[[@as MapPosition]]
	local pos2 = v(position):add(radius)      --[[@as MapPosition]]

	local all_found_at = core.find_nodes_in_area(pos1, pos2, node_names)

	--- @type table<Position,NodeTable>
	local result = {}
	for i, found_at in ipairs(all_found_at) do
		if search_in_center or (not search_in_center and v(found_at) ~= v(position)) then
			result[found_at] = core.get_node(found_at)
		end
	end

	return result
end

--- @param node              NodeTable
--- @param except_node_names table     Nodes to exclude. (e.g. `{"ignore", "group:tree"}` or `"default:dirt"`)
local function should_be_excluded(node, except_node_names)
	for _, except in ipairs(except_node_names) do
		local group = except:match("^group:(.+)$")
		if group then
			if core.get_item_group(node.name, group) > 0 then
				return true
			end
		elseif node.name == except then
			return true
		end
	end

	return false
end

--- Finds node(s) near position, excluding specified nodes/groups.
---
--- If no node(s) found, returns:
---  - `nil, nil` - for `only_first`
---  - `{}, nil`  - for not `only_first`
---
--- @param position          MapPosition  Center position to search around.
--- @param radius            number       Search radius.
--- @param node_names        table|string Nodes to search. (e.g. `{"ignore", "group:tree"}` or `"default:dirt"`)
--- @param except_node_names table|string Nodes to exclude. (e.g. `{"ignore", "group:tree"}` or `"default:dirt"`)
--- @param search_in_center  boolean      Optional. Include center position (default: false)
--- @param only_first        boolean      Optional. Return only first found node (default: false)
--- @return table<Position,NodeTable>|Position|nil, nil|NodeTable Found filtered node(s).
function core.find_nodes_near_except(position, radius, node_names, except_node_names, search_in_center, only_first)
	--- @type table
	except_node_names = type(except_node_names) == 'string' and { except_node_names } or except_node_names or {}

	local all_found = core.find_nodes_near(position, radius, node_names, search_in_center)

	--- @type table<Position,NodeTable>
	local filtered = {}
	for pos, node in pairs(all_found) do
		local excluded = should_be_excluded(node, except_node_names)

		if not excluded then
			if only_first then
				return pos, node
			end

			filtered[pos] = node
		end
	end

	if only_first then
		return nil, nil
	else
		return filtered, nil
	end
end

--- Finds first matching node near position (with exceptions).
---
--- @param position          MapPosition  Center position to search around.
--- @param radius            number       Search radius.
--- @param node_names        table|string Nodes to search. (e.g. `{"ignore", "group:tree"}` or `"default:dirt"`)
--- @param except_node_names table|string Nodes to exclude. (e.g. `{"ignore", "group:tree"}` or `"default:dirt"`)
--- @param search_in_center  boolean      Optional. Include center position (default: false)
---
--- @return Position|nil, NodeTable|nil
function core.find_node_near_except(position, radius, node_names, except_node_names, search_in_center)
	--- @diagnostic disable-next-line: return-type-mismatch
	return core.find_nodes_near_except(position, radius, node_names, except_node_names, search_in_center, true)
end
