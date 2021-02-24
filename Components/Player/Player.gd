extends Node2D


onready var map=$"../Map"
onready var overlay=$Overlay

export(Resource) var road: Resource
export(Resource) var tent: Resource

var selected_build_item: Resource
var selected_build_item_size

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
		if map.can_build_area(mouse_tile, selected_build_item_size):
			overlay.modulate=green_color
		else:
			overlay.modulate=red_color
		
		overlay.scale=Vector2.ONE*selected_build_item_size		
		overlay.position=overlay_pos


func _on_tile_selected(tile):
	if selected_build_item==road:
		if map.can_build(tile):
			map.build_road(tile, 0)
	elif selected_build_item==tent:
		if map.can_build_area(tile, selected_build_item_size):
			map.build(tile, tent, selected_build_item_size)
			deselect_build()




func deselect_build():
	selected_build_item=null
	selected_build_item_size=null
	overlay.visible=false

func _on_GUI_press(button: String):
	if button=="build_road":
		selected_build_item=road
		selected_build_item_size=Vector2.ONE
	elif button == "build_tent":
		selected_build_item=tent
		selected_build_item_size=Vector2(4,3)
