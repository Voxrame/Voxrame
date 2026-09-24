
--- @class (partial) Voxrame
Voxrame = Voxrame or {}

--- @class Voxrame.map
Voxrame.map = {
	--- @type Voxrame.map.Room
	Room = require('map.Room'),
	--- @type Voxrame.map.Corridor
	Corridor = require('map.Corridor'),
	--- @class Voxrame.map.room
	room = {
		--- @type Voxrame.map.room.Wall
		Wall  = require('map.room.Wall'),
		--- @class Voxrame.map.room.wall
		wall  = {
			--- @type Voxrame.map.room.wall.Type
			Type = require('map.room.wall.Type')
		},
		--- @type Voxrame.map.room.Walls
		Walls = require('map.room.Walls'),
		--- @type Voxrame.map.room.Exit
		Exit  = require('map.room.Exit'),
	},
}
