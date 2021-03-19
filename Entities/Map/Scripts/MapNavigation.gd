class_name MapNavigation

var _map
var _roads

func _init(map, roads):
	_map=map
	_roads=roads

func find_path(from: Vector2, to: Vector2)->PoolVector2Array:
	return _roads.find_path(from, to)

func get_road_path_to_building(from_tile: Vector2, to_tile: Vector2)->PoolVector2Array:
	var tilesB=get_road_tiles_next_to(to_tile)
	var selected_path=PoolVector2Array()
	
	for j in tilesB:
		var candidate_path=find_path(from_tile, j)
		if candidate_path.size() > 0:
			if selected_path.size() == 0 or candidate_path.size() < selected_path.size():
				selected_path=candidate_path
	return selected_path
	

func get_road_path_between_buildings(tile1: Vector2, tile2: Vector2) -> PoolVector2Array:
	var tilesA=get_road_tiles_next_to(tile1)
	var tilesB=get_road_tiles_next_to(tile2)
	var selected_path=PoolVector2Array()
	
	for i in tilesA:
		for j in tilesB:
			var candidate_path=find_path(i, j)
			if candidate_path.size() > 0:
				if selected_path.size() == 0 or candidate_path.size() < selected_path.size():
					selected_path=candidate_path
	return selected_path

func get_closest_building_of_groups(from: Vector2, building_groups: Array) -> Building:
	var buildings=_map.get_buildings_of_groups(building_groups)
	
	return get_closest_building_from_list(from, buildings)


func get_closest_building_from_list(from: Vector2, buildings: Array) -> Building:
	var closest_building=null
	var shortest_path=[]

	for building in buildings:
		var candidate_path=get_road_path_between_buildings(from, building.map_position)
		if candidate_path.size() > 0:
			if shortest_path.size() == 0 or candidate_path.size() < shortest_path.size():
				shortest_path=candidate_path
				closest_building=building
	return closest_building


func get_road_tiles_next_to(tile: Vector2) -> Array:
	var tiles=[]
	for i in range(tile.x-1,tile.x+2):
		for j in range(tile.y-1, tile.y+2):
			var current_tile=Vector2(i,j)
			if current_tile!=tile and not _is_diagonal(tile, current_tile):
				if _roads.get_cell(current_tile.x, current_tile.y)!=-1:
					tiles.append(current_tile)
	return tiles

func _is_diagonal(tile1:Vector2, tile2:Vector2)-> bool:
	return tile1.x!=tile2.x and tile1.y!=tile2.y
