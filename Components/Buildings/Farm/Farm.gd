extends Building

export var worker:PackedScene
export var production_rate:float=1
export var max_storage:int=10

var current_food:float=0

func on_building_update(delta: float):
	_produce_food(delta)
	print(current_food, max_storage)
	if current_food>=max_storage:
		_spawn_farmer()

func _produce_food(delta: float):
	if current_food<max_storage:
		var food_produced=production_rate*delta
		current_food=clamp(current_food+food_produced, 0, max_storage)

func _spawn_farmer():
	var road_tiles=map.navigation.get_road_tiles_next_to(map_position)
	if road_tiles.size()>0:
		var tile=road_tiles[0]
		_spawn_farmer_instance(tile)
		current_food=0

func on_building_select():
	.on_building_select()
	print("farm clicked")



func _spawn_farmer_instance(position: Vector2):
	var instance=worker.instance()
	instance.map=map
	instance.map_position=position
	instance.origin_building=self
	map.add_person(instance)


	### For more intelligent spawn
	#var building = map.navigation.get_closest_building_of_type(map_position, "house")
	
	#if building:
	#	var path=map.navigation.get_road_path_between_buildings(map_position, building.map_position)
	#	var instance=worker.instance()
	#	instance.map=map
	#	instance.map_position=path[0]
	#	map.add_person(instance)
		#instance.set_path(path)
