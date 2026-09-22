local voxrame_path = debug.getinfo(1).source:sub(2):match('?(.*[\\/])') or ''

local function extend(self, config)
    for key, value in pairs(config) do
        if type(key) == 'string' then
            self[key] = type(value) == 'table'
                and extend(self[key] or {}, value)
                or value
        else
            table.insert(self, value)
        end
    end

    return self
end


return {
    -- voxrame_path = voxrame_path,
    extend       = extend,

    -- -------------------------------------------------

    std               = 'lua51',

    unused_args       = false,
    allow_defined_top = true,

    globals           = {
        'minetest', 'core',
    },

    read_globals      = {
		table  = { fields = {
			-- Luanti Builtin:
			"copy", "copy_with_metatables", "insert_all",
			"indexof", "keyof", "key_value_swap", "shuffle",
			-- Voxrame/helpers:
			"contains", "has_value", "has_key", "merge", "join", "merge_values",
			"is_empty", "overwrite", "keys_of", "count", "keys", "values",
			"only", "except", "keys_has_one_of_values", "equals", "multiply_each_value",
			"map", "add_values", "sub_values", "mul_values", "div_values",
			"generate_sequence", "is_position", "walk"
		} },

		string = { fields = {
			-- Luanti Builtin:
			"split", "trim", "pack", "unpack", "packsize",
			-- Voxrame/helpers:
			"is_one_of", "replace", "contains", "starts_with", "ends_with", "vxr_split", "or_nil"
		} },

		math = { fields = {
			-- Luanti Builtin:
			"sign", "hypot", "factorial", "round",
			-- Voxrame/helpers:
			"limit", "clamp",
			"is_within", "is_among", "is_in_range", "is_near", "point_on_circle"
		} },

		io = { fields = {
			-- Voxrame/helpers:
			"file_exists", "write_to_file", "read_from_file", "dirname", "get_file_error"
		} },

		os = { fields = {
			-- Voxrame/helpers:
			"DIRECTORY_SEPARATOR",
		} },

		debug  = { fields = {
			-- Voxrame/helpers:
			"get_function_code", "get_passed_params", "get_file_code",
			"get_stack_frames", "render_backtrace", "print_backtrace",
			"measure", "measure_print"
		} },

		-- Builtin
		"vector", "nodeupdate", "PseudoRandom",
		"VoxelManip", "VoxelArea",
		"ItemStack", "Settings",
		"dump", "DIR_DELIM",
		-- Legacy function
		"spawn_falling_node",
	},

	files         = {
		-- Lua extending only in specific files:
		[voxrame_path .. 'helpers/src/lua_ext/**/*.lua'] = {	
			globals = { 'table', 'string', 'math', 'io', 'os', 'debug' }
		},
		-- Extend built-in globals only in specific files:
		[voxrame_path .. 'builtin_ext/src/**/*.lua'] = {
			globals = { 'VoxelArea', 'vector' }
		}
	}
}
