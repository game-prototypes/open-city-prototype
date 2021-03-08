extends Node

class_name MapNavigation

onready var _map:Map=$".."
onready var _roads:Map=$"../Roads"

func find_path(from: Vector2, to: Vector2)->PoolVector2Array:
	return _roads.find_path(from, to)


func get_road_path(tile1: Vector2, tile2: Vector2) -> PoolVector2Array:
	var tilesA=_map.get_road_tiles_next_to(tile1)
	var tilesB=_map.get_road_tiles_next_to(tile2)
	var selected_path=PoolVector2Array()
	
	for i in tilesA:
		for j in tilesB:
			var candidate_path=find_path(i, j)
			if candidate_path.size() > 0:
				if selected_path.size() == 0 or candidate_path.size() < selected_path.size():
					selected_path=candidate_path

	return selected_path

func get_closest_building_of_type(from: Vector2, building_type: String) -> Building:
	var buildings=_map.get_buildings_of_type(building_type)
	
	var closest_building=null
	var shortest_path=[]

	for building in buildings:
		var candidate_path=get_road_path(from, building.map_position)
		if candidate_path.size() > 0:
			if shortest_path.size() == 0 or candidate_path.size() < shortest_path.size():
				shortest_path=candidate_path
				closest_building=building
	return closest_building
