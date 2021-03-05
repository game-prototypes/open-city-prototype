extends Node2D


export(Array, Resource) var buildings

onready var gui = $GUI
onready var player = $Player
onready var map = $Map

func _ready():
	gui.set_buildings(buildings)
	gui.connect("building_selected", player,"on_building_selected")
	map.connect("tile_selected", player, "on_tile_selected")
	
	CityResources.connect("money_updated", gui, "on_money_updated")
	CityResources.add_money(0) # To kickstart the signals
