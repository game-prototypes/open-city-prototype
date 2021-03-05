extends Node2D


export var overlay_tile: PackedScene


onready var map: Map=$"../Map"
onready var overlay=$Overlay

var selected_build_item: Resource

var green_color=Color("#9516820f")
var red_color=Color("#9582170f")

func _process(_delta):
	if selected_build_item:
		var mouse_tile=map.pos2tile(get_global_mouse_position())
		var overlay_pos=map.tile2pos(mouse_tile)
		
		overlay.visible=true
		if map.can_build_area(mouse_tile, selected_build_item.area):
			overlay.modulate=green_color
		else:
			overlay.modulate=red_color
		
		overlay.position=overlay_pos


func deselect_build():
	selected_build_item=null
	overlay.visible=false
	_remove_overlay()

func on_tile_selected(tile: Vector2) -> void:
	if selected_build_item == null:
		pass
	elif selected_build_item.type==BuildingResource.Type.ROAD:
		if map.can_build(tile):
			map.build_road(tile, selected_build_item.road_id)
			CityResources.remove_money(selected_build_item.price)
	elif selected_build_item.type==BuildingResource.Type.BUILDING:
		if map.can_build_area(tile, selected_build_item.area):
			var building = selected_build_item.instantiate_building()
			map.build(tile,building, selected_build_item.area)
			CityResources.remove_money(selected_build_item.price)
			deselect_build()

func on_building_selected(building: Resource):
	selected_build_item=building
	_set_overlay(selected_build_item.area)


func _set_overlay(area:Vector2):
	for i in area.x:
		for j in area.y:
			var instance=overlay_tile.instance()
			instance.position=map.tile2pos(Vector2(i,j))
			overlay.add_child(instance)

func _remove_overlay():
	for n in overlay.get_children():
		overlay.remove_child(n)
		n.queue_free()
