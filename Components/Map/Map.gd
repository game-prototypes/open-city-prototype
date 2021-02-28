extends Node2D

class_name Map

onready var terrain:TileMap = $Terrain
onready var roads:TileMap = $RoadNavigation/Roads
onready var navigation:Navigation2D = $RoadNavigation
onready var buildings: TileMap = $Buildings
onready var elements = $Elements

var tile_size: int

const BUILDINGS_GROUP = "buildings"
signal tile_selected(tile, building)

var blocked_tile_id: int

func _ready():
	assert(terrain.cell_size[0]==roads.cell_size[0], "Error, terrain tile size != roads tile size")
	assert(buildings.cell_size[0]==roads.cell_size[0], "Error, buildings tile size != roads tile size")
	
	tile_size=terrain.cell_size[0]
	
	blocked_tile_id=buildings.tile_set.find_tile_by_name("red")
	assert(blocked_tile_id, "Error, blocked_tile_id not found")

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

func build(tile: Vector2, scene: PackedScene, area: Vector2):
	var build_instance=scene.instance()
	
	build_instance.position=tile2pos(tile)
	build_instance.add_to_group(BUILDINGS_GROUP)
	elements.add_child(build_instance)
	build_area(tile,area)

func build_road(tile: Vector2, road_id: int)-> void:
	roads.set_cell(tile.x, tile.y, road_id)

func build_area(tile: Vector2, area: Vector2) -> void:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			buildings.set_cell(i, j, blocked_tile_id)

func pos2tile(tile: Vector2)->Vector2:
	return terrain.world_to_map(tile)

# Returns top left corner
func tile2pos(tile: Vector2)->Vector2:
	return terrain.map_to_world(tile)
	
func get_tile_size()->int:
	return tile_size

func find_path(from: Vector2, to: Vector2)->PoolVector2Array:
	return navigation.get_simple_path(from,to)

 # Only receives uncaptured inputs
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var cell=pos2tile(get_global_mouse_position())
			emit_signal("tile_selected", cell)
