local mod_path    = core.get_modpath(core.get_current_modname())
local old_require = require
require           = function(name) return dofile(mod_path .. '/src/' .. name:gsub('%.', '/') .. '.lua') end


Voxrame = rawget(_G, 'Voxrame') or {}

Voxrame.helpers  = 'loaded'
Voxrame.terminal = require('terminal')

require('types')
require('lua_ext.global')
require('lua_ext.table')
require('lua_ext.string')
require('lua_ext.math')
require('lua_ext.io')
require('lua_ext.os')
require('lua_ext.debug')


require = old_require
