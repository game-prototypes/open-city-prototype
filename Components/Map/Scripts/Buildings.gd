extends TileMap # TODO: remove this and use dictionary instead?

class_name Buildings

const BUILDINGS_GROUP = "buildings"

var blocked_tile_id: int

var tile_to_building: Dictionary = Dictionary()

func _ready():
	blocked_tile_id=tile_set.find_tile_by_name("red")
	assert(blocked_tile_id, "Error, blocked_tile_id not found")

func build(tile: Vector2, building: Node2D):
	building.position=map_to_world(tile)
	building.add_to_group(BUILDINGS_GROUP)
	_build_area(building)

func remove_building_from_tile(tile: Vector2):
	var building=tile_to_building.get(tile)
	var tiles=building.get_occupied_tiles()
	building.queue_free()
	_demolish_area(tiles)

func has_building(tile: Vector2)->bool:
	return tile_to_building.has(tile)

func handle_building_click(tile: Vector2):
	if tile_to_building.has(tile):
		var element=tile_to_building[tile]
		element.on_building_select()

func _build_area(building:Node2D) -> void:
	var tiles=building.get_occupied_tiles()
	for tile in tiles:
		set_cell(tile.x, tile.y, blocked_tile_id)
		tile_to_building[tile]=building

func _demolish_area(tiles: Array) -> void:
	for tile in tiles:
		set_cell(tile.x, tile.y, -1)
		tile_to_building.erase(tile)
