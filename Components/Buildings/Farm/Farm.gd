extends Building

export var worker:PackedScene


func _on_building_select():
	._on_building_select()
	
	var road_tiles=get_road_tiles_next_to_building()
	print("farm clicked ", road_tiles)
	if road_tiles.size() > 0:
		var instance=worker.instance()

		instance.position=map.tile2pos(road_tiles[0])
		map.add_person(instance)
