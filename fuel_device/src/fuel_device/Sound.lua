-- sound functions

--- Parent class of default sound parameters
--- @class fuel_device.Sound
local Sound = {
	sound_file = nil,
	parameters = {},
	now_playing = {}
}

--- Play repeated sound file defined in node_def.sound_device
--- @param position Position
--- @param sound_device table|nil
function Sound.start_at(position, sound_device)
	if not sound_device then return end
	sound_device.parameters.pos = position
	sound_device.parameters.loop = true
	local hash = core.hash_node_position(position)
	if Sound.now_playing[hash] then
		Sound.stop_at(position)
	end
	local sound_id = core.sound_play(sound_device.file, sound_device.parameters)
	Sound.now_playing[hash] = sound_id
end

--- Play single sound file defined in node_def.sound_output
--- @param position Position
--- @param sound_output table|nil
function Sound.play_once_at(position, sound_output)
	if not sound_output then return end
	sound_output.parameters.pos = position
	sound_output.parameters.loop = false
	core.sound_play(sound_output.file, sound_output.parameters)
end

--- Stop playng sound in node position
--- @param position Position
function Sound.stop_at(position)
	local hash = core.hash_node_position(position)
	local sound_id = Sound.now_playing[hash]
	if not sound_id then return end
	core.sound_stop(sound_id)
	Sound.now_playing[hash] = nil
end

return Sound
