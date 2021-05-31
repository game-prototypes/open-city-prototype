extends Node

var game_data

func set_game_data(data):
	game_data=data

func get_game_data() -> Dictionary:
	return game_data

func clear_game_data():
	game_data=null
