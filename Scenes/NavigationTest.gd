extends Node2D

onready var navigation:Navigation2D= $Navigation2D
onready var tilemap:TileMap=$Navigation2D/TileMap
onready var icon = $icon
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
		var new_path:=navigation.get_simple_path(icon.global_position, event.global_position)
		var path=PoolVector2Array()
		for p in new_path:
			print(tilemap.world_to_map(p))
			path.append(p)
			#path.append(pos2cell2pos(p))
		print("path", path)
		line.points=path
	if event.button_index==BUTTON_RIGHT:
		var tile=tilemap.world_to_map(event.global_position)
		var tile_value=tilemap.get_cell(tile.x,tile.y)
		if tile_value==-1:
			tilemap.set_cell(tile.x, tile.y,0)
		if tile_value==0:
			tilemap.set_cell(tile.x, tile.y,-1)


func pos2cell2pos(pos):
	var size=tilemap.cell_size/2
	var original_vector= tilemap.map_to_world(tilemap.world_to_map(pos))
	return original_vector
	#return Vector2(original_vector.x+size.x, original_vector.y+size.y)
