extends Node

class_name MapBuildings

onready var map=get_parent()

var blocked_tile_id: int

var tile_to_building := Dictionary()

func build(tile: Vector2, building: Node2D):
	building.position=map.tile2pos(tile)
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
		return tile_to_building[tile]

func get_buildings()->Array:
	return tile_to_building.values()

func _build_area(building:Node2D) -> void:
	var tiles=building.get_occupied_tiles()
	for tile in tiles:
		tile_to_building[tile]=building

func _demolish_area(tiles: Array) -> void:
	for tile in tiles:
		tile_to_building.erase(tile)
