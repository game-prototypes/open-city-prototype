extends Building

class_name ProductionBuilding

export var transporter_character:PackedScene
export var production_rate:float=1
export var max_storage:int=10
export(Global.RESOURCES) var resource
export var target_building: String

var current_ammount:float=0

func on_building_update(delta: float):
	.on_building_update(delta)
	_produce_food(delta)
	if current_ammount>=max_storage:
		_spawn_transporter()


func on_building_select():
	.on_building_select()

func _produce_food(delta: float):
	if current_ammount<max_storage:
		var food_produced=production_rate*delta
		current_ammount=clamp(current_ammount+food_produced, 0, max_storage)

func _spawn_transporter():
	var tile=_get_closer_spawn_tile(target_building)
	if tile:
		_spawn_transporter_instance(tile)
		current_ammount=0

func _spawn_transporter_instance(position: Vector2):
	var instance=transporter_character.instance() as Transporter
	instance.map=map
	instance.map_position=position
	instance.target_building_group=target_building
	instance.origin_building=self
	instance.resource_type = resource
	instance.resource_ammount=current_ammount
	map.add_person(instance)

func _get_closer_spawn_tile(target_building_group:String):
	var building = map.navigation.get_closest_building_of_type(map_position, target_building_group)
	
	if building:
		var path=map.navigation.get_road_path_between_buildings(map_position, building.map_position)
		return path[0]


func _get_random_spawn_tile():
	var road_tiles=map.navigation.get_road_tiles_next_to(map_position)
	if road_tiles.size()>0:
		# TODO: random
		return road_tiles[0]
