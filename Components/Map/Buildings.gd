extends TileMap

class_name Buildings

const BUILDINGS_GROUP = "buildings"

var blocked_tile_id: int

func _ready():
	blocked_tile_id=tile_set.find_tile_by_name("red")
	assert(blocked_tile_id, "Error, blocked_tile_id not found")

func build(tile: Vector2, building: Node2D, area: Vector2):
	building.position=map_to_world(tile)
	print(tile, building.position)
	building.add_to_group(BUILDINGS_GROUP)
	_build_area(tile,area)

func _build_area(tile: Vector2, area: Vector2) -> void:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			set_cell(i, j, blocked_tile_id)
