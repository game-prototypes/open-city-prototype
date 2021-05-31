extends CanvasLayer

export(PackedScene) var main_scene

func _on_new_game() -> void:
	Store.set_game_data({})
	get_tree().change_scene_to(main_scene)

func _on_load_game() -> void:
	var data=load_game_data("res://savegame.json")
	Store.set_game_data(data)
	
	get_tree().change_scene_to(main_scene)

func load_game_data(file:String) -> Dictionary:
	var save_game = File.new()
	save_game.open(file, File.READ)
	var data=save_game.get_line()
	var game_data=JSON.parse(data)
	save_game.close()
	return game_data.result
