extends Node

export(Array, Resource) var buildings

onready var gui: = $GUI
onready var player: = $Player
onready var map: = $Map
onready var building_update_timer:=$BuildingUpdateTimer

func _ready():
	Log.info("Begin Main Scene")
	gui.set_buildings(buildings)
	
	_setup_signals()


func on_building_timer():
	get_tree().call_group("building", "on_building_update", building_update_timer.wait_time)
	gui.on_building_update()

func _setup_signals():
	gui.connect("building_resource_selected", player,"on_building_resource_selected")
	gui.connect("demolish_building_selected", player,"on_demolish_building_selected")
	map.connect("tile_selected", player, "on_tile_selected")
	player.connect("building_selected", gui, "show_building_info")
	building_update_timer.connect("timeout", self, "on_building_timer")
	#building_update_timer.connect("timeout", gui, "on_building_update")
	
	CityResources.connect("money_updated", gui, "on_money_updated")
	CityResources.add_money(0) # To kickstart the signals