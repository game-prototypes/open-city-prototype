extends Building

export var worker:PackedScene


func _on_building_select():
	._on_building_select()
	print("farm clicked")
	
	var building = map.navigation.get_closest_building_of_type(map_position, "house")
	
	if building:
		var path=map.navigation.get_road_path(map_position, building.map_position)
		var instance=worker.instance()
		instance.map=map
		instance.position=map.tile2pos(path[0])
		map.add_person(instance)
		instance.set_path(path)
