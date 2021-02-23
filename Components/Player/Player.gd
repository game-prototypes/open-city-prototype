extends Node2D


onready var map=$"../Map"
onready var overlay=$Overlay

export(Resource) var road: Resource
export(Resource) var tent: Resource

var selected_build_item: Resource

var green_color=Color("#9516820f")
var red_color=Color("#9582170f")

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(road)
	assert(tent)

func _process(_delta):
	if selected_build_item:
		var tile_size=map.get_tile_size()
		var mouse_tile=map.pos2tile(get_global_mouse_position())
		var overlay_pos=mouse_tile*tile_size
		
		overlay.visible=true
		if map.can_build(mouse_tile):
			overlay.modulate=green_color
		else:
			overlay.modulate=red_color
		overlay.position=Vector2(overlay_pos.x+tile_size/2,overlay_pos.y+tile_size/2)


func _on_tile_selected(tile):
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
