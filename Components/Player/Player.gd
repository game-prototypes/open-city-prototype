extends Node


onready var map=$"../Map"
export(Resource) var road: Resource
export(Resource) var tent: Resource

var selected_build_item: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(road)
	assert(tent)

func _on_tile_selected(tile):
	#map.build(tile, road)
	if selected_build_item==road:
		if map.can_build(tile):
			map.build_road(tile, 0)
	elif selected_build_item==tent:
		if can_build_range(tile, 4):
			map.build(tile, tent, 4)

func can_build_range(tile, side) -> bool:
	for i in range(tile.x,tile.x+side):
		for j in range(tile.y, tile.y+side):
			if not map.can_build(Vector2(i, j)):
				return false
	return true


func _on_GUI_press(button: String):
	if button=="build_road":
		selected_build_item=road
	elif button == "build_tent":
		selected_build_item=tent
