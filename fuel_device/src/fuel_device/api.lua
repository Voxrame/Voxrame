local Device    = require('fuel_device.Device')
local Sound     = require('fuel_device.Sound')
local Processor = require('fuel_device.Processor')
local node      = require('fuel_device.node')


return {
	Device    = Device,
	Sound     = Sound,
	Processor = Processor,
	register  = node.register,
}
