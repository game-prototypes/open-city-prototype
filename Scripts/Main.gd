extends Node

export(Array, Resource) var buildings

onready var gui: = $GUI
onready var player: = $Player
onready var map: = $Map
onready var buildingUpdateTimer:=$BuildingUpdateTimer

func _ready():
	Log.info("Begin Main Scene")
	gui.set_buildings(buildings)
	gui.connect("building_selected", player,"on_building_selected")
	gui.connect("demolish_building_selected", player,"on_demolish_building_selected")
	map.connect("tile_selected", player, "on_tile_selected")
	buildingUpdateTimer.connect("timeout", self, "on_building_timer")
	
	CityResources.connect("money_updated", gui, "on_money_updated")
	CityResources.add_money(0) # To kickstart the signals
	
	
func on_building_timer():
	get_tree().call_group("building", "on_building_update", buildingUpdateTimer.wait_time)
