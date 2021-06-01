extends Node

onready var hud: = $HUD
onready var player: = $Player
onready var map: = $Map
onready var building_update_timer:=$BuildingUpdateTimer

onready var city=ServiceLocator.get_city()

func _ready():
	city.set_map(map)
	_setup_signals()
	city.begin_game(Store.get_game_data())
	Store.clear_game_data()


func on_building_timer():
	get_tree().call_group("building", "on_building_update", building_update_timer.wait_time)

func save():
	var filename="res://savegame.json"
	Log.info("Save Game", filename)
	var result=map.serialize()
	result["city"]=city.serialize()
	var save_game = File.new()
	save_game.open(filename, File.WRITE)
	save_game.store_line(JSON.print(result))
	save_game.close()

func _setup_signals():
	hud.connect("building_resource_selected", player,"on_building_resource_selected")
	hud.connect("demolish_building_selected", player,"on_demolish_building_selected")
	hud.connect("save", self,"save")
	map.connect("tile_selected", player, "on_tile_selected")
	player.connect("building_selected", hud, "show_building_info")
	building_update_timer.connect("timeout", self, "on_building_timer")
	
	city.connect("money_updated", hud, "on_money_updated")
	city.connect("population_updated", hud, "on_population_updated")
	city.add_money(0) # To kickstart the signals
