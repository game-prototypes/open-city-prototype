extends Node

export(Array, Resource) var buildings

var _game_data

func set_game_data(data):
	_game_data=data

func get_game_data() -> Dictionary:
	return _game_data

func clear_game_data():
	_game_data=null

func get_building_resource(name: String):
	for building in buildings:
		if building.name==name:
			return building
	assert(false, "Building "+name+" not found")

func get_building_resources()->Array:
	return buildings
