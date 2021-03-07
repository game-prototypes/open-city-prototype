extends Node2D

onready var roads:Roads=$Roads
onready var icon = $Icon
onready var line:Line2D=$Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event:InputEvent):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index==BUTTON_LEFT:
		var icon_tile=roads.world_to_map(icon.global_position)
		var clicked_tile=roads.world_to_map(get_global_mouse_position())
		var new_path:=roads.find_path(icon_tile, clicked_tile)
		var path=PoolVector2Array()
		for p in new_path:
			path.append(tile_center_pos(p))
		line.points=path
	if event.button_index==BUTTON_RIGHT:
		var tile=roads.world_to_map(get_global_mouse_position())
		var tile_value=roads.get_cell(tile.x,tile.y)
		if tile_value==-1:
			roads.build_road(tile, 1)
		if tile_value!=-1:
			roads.remove_road(tile)



func tile_center_pos(tile):
	var half_size=roads.cell_size.y/2
	var top_tile_pos=roads.map_to_world(tile)
	return Vector2(top_tile_pos.x, top_tile_pos.y+half_size)