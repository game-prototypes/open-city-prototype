extends TileMap

class_name Roads

var astar = AStar2D.new()
const MAX_SIZE=10000

func _init():
	var tiles=get_used_cells()
	for tile in tiles:
		_add_walkable_tile(tile)

func build_road(tile: Vector2, road_id: int) -> void:
	set_cell(int(tile.x), int(tile.y), road_id)
	_add_walkable_tile(tile)
	
func remove_road(tile: Vector2):
	set_cell(int(tile.x), int(tile.y), -1)
	_remove_walkable_tile(tile)

func has_road(tile: Vector2)->bool:
	return get_cell(tile.x, tile.y)!=-1

func find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var from_id=_calculate_point_index(from)
	var to_id=_calculate_point_index(to)
	if !astar.has_point(from_id) or !astar.has_point(to_id):
		return PoolVector2Array()
	return astar.get_point_path(from_id,to_id)

func _remove_walkable_tile(tile: Vector2):
	var id=_calculate_point_index(tile)
	astar.remove_point(id)

func _add_walkable_tile(tile: Vector2):
	var id=_calculate_point_index(tile)
	astar.add_point(id, tile)
	_connect_tile(tile)

func _connect_tile(tile:Vector2):
	var tile_id=_calculate_point_index(tile)
	
	for local_y in range(3):
		for local_x in range(3):
			var relative_tile = Vector2(tile.x + local_x - 1, tile.y + local_y - 1)
			var relative_tile_id = _calculate_point_index(relative_tile)
			if not astar.has_point(relative_tile_id):
				continue
			if _can_connect_points(tile, relative_tile):
				astar.connect_points(tile_id, relative_tile_id, true)

func _calculate_point_index(point: Vector2) -> int:
	return int(point.x + MAX_SIZE * point.y)


func _can_connect_points(cell1: Vector2, cell2: Vector2) -> bool:
	if cell1==cell2:
		return false
	if cell1.x != cell2.x and cell1.y!=cell2.y:
		return false
	return true
