extends CanvasLayer

export(PackedScene) var main_scene

func _ready():
	Log.version()

func _on_new_game() -> void:
	Log.info("Start New Game")
	Store.set_game_data({})
	get_tree().change_scene_to(main_scene)

func _on_load_game() -> void:
	var filename="res://savegame.json"
	Log.info("Load game", filename)
	var data=_load_game_data(filename)
	Store.set_game_data(data)
	
	get_tree().change_scene_to(main_scene)

func _load_game_data(file:String) -> Dictionary:
	var save_game = File.new()
	save_game.open(file, File.READ)
	var data=save_game.get_line()
	var game_data=JSON.parse(data)
	save_game.close()
	return game_data.result
