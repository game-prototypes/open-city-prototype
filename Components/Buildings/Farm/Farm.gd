extends Building

export var worker:PackedScene


func _on_building_select():
	._on_building_select()
	print("farm clicked")
	
	var road_tiles=map.navigation.get_road_tiles_next_to(map_position)
	if road_tiles.size()>0:
		var tile=road_tiles[0]
		_spawn_farmer(tile)
		
	### For more intelligent spawn
	#var building = map.navigation.get_closest_building_of_type(map_position, "house")
	
	#if building:
	#	var path=map.navigation.get_road_path_between_buildings(map_position, building.map_position)
	#	var instance=worker.instance()
	#	instance.map=map
	#	instance.map_position=path[0]
	#	map.add_person(instance)
		#instance.set_path(path)

func _spawn_farmer(position: Vector2):
	var instance=worker.instance()
	instance.map=map
	instance.map_position=position
	map.add_person(instance)
