extends Node2D


export(Array, Resource) var buildings

onready var gui = $GUI
onready var player = $Player
onready var map = $Map
onready var city_resources: CityResources = $CityResources

func _ready():
	gui.set_buildings(buildings)
	gui.connect("building_selected", player,"on_building_selected")
	map.connect("tile_selected", player, "on_tile_selected")
	
	city_resources.connect("money_updated", gui, "on_money_updated")
	city_resources.add_money(100)
	
