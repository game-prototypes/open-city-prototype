extends Node2D

onready var map: Map=$"../Map"
onready var overlay=$Overlay

var selected_build_item: BuildingResource

var green_color=Color("#9516820f")
var red_color=Color("#9582170f")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if selected_build_item:
		var tile_size=map.get_tile_size()
		var mouse_tile=map.pos2tile(get_global_mouse_position())
		var overlay_pos=mouse_tile*tile_size
		
		overlay.visible=true
		if map.can_build_area(mouse_tile, selected_build_item.area):
			overlay.modulate=green_color
		else:
			overlay.modulate=red_color
		
		overlay.scale=Vector2.ONE*selected_build_item.area
		overlay.position=overlay_pos



func deselect_build():
	selected_build_item=null
	overlay.visible=false

func _on_tile_selected(tile: Vector2) -> void:
	if selected_build_item == null:
		pass
	elif selected_build_item.type==BuildingResource.Type.ROAD:
		if map.can_build(tile):
			map.build_road(tile, selected_build_item.road_id)
	elif selected_build_item.type==BuildingResource.Type.BUILDING:
		if map.can_build_area(tile, selected_build_item.area):
			var building = selected_build_item.instantiate_building()
			map.build(tile,building, selected_build_item.area)
			deselect_build()

func _on_building_selected(building: Resource):
	selected_build_item=building
