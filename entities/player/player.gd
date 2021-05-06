extends Node2D

signal building_selected(building)

export var overlay_tile: PackedScene

onready var map=$"../Map"
onready var overlay=$Overlay

var selected_build_item: Resource
var selected_demolish=false

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
	if selected_demolish:
		var mouse_tile=map.pos2tile(get_global_mouse_position())
		var overlay_pos=map.tile2pos(mouse_tile)
		overlay.visible=true
		overlay.position=overlay_pos
		overlay.modulate=red_color

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			deselect_action()


func deselect_action():
	selected_build_item=null
	overlay.visible=false
	selected_demolish=false
	_remove_overlay()

func on_tile_selected(tile: Vector2, selected_element) -> void:
	# TODO: use a generic action abstraction
	if not selected_build_item:
		if selected_element:
			if selected_element.is_in_group(Global.BUILDING_GROUP):
				emit_signal("building_selected", selected_element)
	elif selected_build_item.type==BuildingResource.Type.ROAD:
		if map.can_build(tile):
			map.build_road(tile, selected_build_item.road_id)
			City.remove_money(selected_build_item.price)
	elif selected_build_item.type==BuildingResource.Type.BUILDING:
		if map.can_build_area(tile, selected_build_item.area):
			var building = selected_build_item.instantiate_building(tile)
			map.build(building)
			City.remove_money(selected_build_item.price)

	if selected_demolish:
		if map.demolish_tile(tile):
			City.remove_money(5)

func on_building_resource_selected(building: Resource):
	deselect_action()
	selected_build_item=building
	_set_overlay(selected_build_item.area)

func on_demolish_building_selected():
	deselect_action()
	_set_overlay(Vector2(1,1))
	selected_demolish=true

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
