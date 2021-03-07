extends Building

export var worker:PackedScene


func _on_building_select():
	._on_building_select()
	print("farm clicked")
	
	var houses=map.get_buildings_of_type("house")
	
	var shortest_path=[]
	
	for house in houses:
		var candidate_path=map.get_shortest_path(map_position, house.map_position)
		if candidate_path.size() > 0:
			if shortest_path.size() == 0 or candidate_path.size() < shortest_path.size():
				shortest_path=candidate_path
	
	if shortest_path.size() > 0:
		print("Path found", shortest_path)
		var instance=worker.instance()
		instance.map=map
		instance.position=map.tile2pos(shortest_path[0])
		map.add_person(instance)
		instance.set_path(shortest_path)
