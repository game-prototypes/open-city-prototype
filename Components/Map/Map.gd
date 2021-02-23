extends Node2D

onready var terrain = $Terrain
onready var roads = $Roads
onready var markers = $Markers
onready var elements =$Elements

var tile_size: int

const BUILDINGS_GROUP = "buildings"
signal tile_selected(tile, building)

func _ready():
	assert(terrain.cell_size[0]==roads.cell_size[0], "Error, terrain tile size != roads tile size")
	tile_size=terrain.cell_size[0]
	print(roads.tile_set.get_tiles_ids(), roads.tile_set.tile_get_name(0))

func can_build(tile) -> bool:
	var road_id=roads.get_cell(tile.x, tile.y)
	return road_id==-1

func build(tile, build, size=1):
	print("Build in ", tile)
	var build_instance=build.instance()
	
	var centered_tile_position=tile2pos(tile)
	# get left top corner
	build_instance.position=Vector2(centered_tile_position.x-tile_size/2, centered_tile_position.y-tile_size/2)
	build_instance.add_to_group(BUILDINGS_GROUP)
	elements.add_child(build_instance)

func build_road(tile: Vector2, road_id: int)-> void:
	print("build road ",road_id, " in tile ", tile)
	roads.set_cell(tile.x, tile.y, road_id)

func pos2tile(coords: Vector2) -> Vector2:
	return Vector2(floor(coords.x/tile_size), floor(coords.y/tile_size))

func tile2pos(cell: Vector2)->Vector2:
	return Vector2(cell.x*tile_size + tile_size/2.0, cell.y*tile_size+tile_size/2.0)
	
func get_tile_size()->int:
	return tile_size

 # Only receives uncapture inputs
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var cell=pos2tile(get_global_mouse_position())
			emit_signal("tile_selected", cell)
