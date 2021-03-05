extends Node2D

class_name Map

onready var terrain:TileMap = $Terrain
onready var roads:Roads = $Roads
onready var buildings:Buildings = $Buildings
onready var elements = $Elements

signal tile_selected(tile, building)

func _ready():
	assert(terrain.cell_size[0]==roads.cell_size[0], "Error, terrain tile size != roads tile size")
	assert(buildings.cell_size[0]==roads.cell_size[0], "Error, buildings tile size != roads tile size")
	
	#_set_collider()


func can_build(tile) -> bool:
	var road_id=roads.get_cell(tile.x, tile.y)
	var building_id=buildings.get_cell(tile.x, tile.y)
	return road_id==-1 and building_id==-1

func can_build_area(tile:Vector2, area: Vector2) -> bool:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			if not can_build(Vector2(i, j)):
				return false
	return true

func build(tile: Vector2, building: Node2D, area: Vector2) -> void:
	buildings.build(tile,building,area)
	elements.add_child(building)
	

func build_road(tile: Vector2, road_id: int)-> void:
	roads.build_road(tile, road_id)

func pos2tile(tile: Vector2)->Vector2:
	return terrain.world_to_map(tile)

# Returns top corner
func tile2pos(tile: Vector2)->Vector2:
	return terrain.map_to_world(tile)

func tile_center_pos(tile: Vector2) -> Vector2:
	var half_size=roads.cell_size.y/2
	var top_tile_pos=roads.map_to_world(tile)
	return Vector2(top_tile_pos.x, top_tile_pos.y+half_size)

func find_path(from: Vector2, to: Vector2)->PoolVector2Array:
	return roads.find_path(from, to)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var cell=pos2tile(get_global_mouse_position())
			print("Map click")
			emit_signal("tile_selected", cell)

func _set_collider():
	var terrain_rect=terrain.get_used_rect()
	var collision_shape: CollisionShape2D=$CollisionShape2D
	
	#var collider_half_size=terrain_rect.size*tile_size/2
	#collision_shape.position=collider_half_size
	#collision_shape.shape.extents=collider_half_size
