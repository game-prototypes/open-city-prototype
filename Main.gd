extends Node2D


export(Array, Resource) var buildings

onready var gui = $GUI
onready var player = $Player
onready var map = $Map


func _ready():
	gui.set_buildings(buildings)
	gui.connect("building_selected", player,"_on_building_selected")
	map.connect("tile_selected", player, "_on_tile_selected")

