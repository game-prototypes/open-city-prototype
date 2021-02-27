extends Node2D

class_name Map

onready var terrain:TileMap = $Terrain
onready var roads:TileMap = $RoadNavigation/Roads
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
	
	var centered_tile_position=tile2pos(tile)
	# get left top corner
	build_instance.position=Vector2(centered_tile_position.x-tile_size/2, centered_tile_position.y-tile_size/2)
	build_instance.add_to_group(BUILDINGS_GROUP)
	elements.add_child(build_instance)
	build_area(tile,area)

func build_road(tile: Vector2, road_id: int)-> void:
	print("build road ",road_id, " in tile ", tile)
	roads.set_cell(tile.x, tile.y, road_id)

func build_area(tile: Vector2, area: Vector2) -> void:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			buildings.set_cell(i, j, blocked_tile_id)

func pos2tile(coords: Vector2) -> Vector2:
	return Vector2(floor(coords.x/tile_size), floor(coords.y/tile_size))

func tile2pos(cell: Vector2)->Vector2:
	return Vector2(cell.x*tile_size + tile_size/2.0, cell.y*tile_size+tile_size/2.0)
	
func get_tile_size()->int:
	return tile_size

 # Only receives uncaptured inputs
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var cell=pos2tile(get_global_mouse_position())
			emit_signal("tile_selected", cell)
