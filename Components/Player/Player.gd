extends Node


onready var map=$"../Map"
export(Resource) var road: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_tile_selected(tile):
	#map.build(tile, road)
	map.build_road(tile, 0)
	

