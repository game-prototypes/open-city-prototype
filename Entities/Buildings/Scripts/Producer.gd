extends Building

class_name Producer

export var transporter_character:PackedScene
export var production_rate:float=1
export var max_storage:int=10
export(Global.RESOURCES) var resource
export var target_building_group: String

var current_ammount:float=0
var transporter: Character

func on_building_update(delta: float):
	.on_building_update(delta)
	_produce_food(delta)
	if current_ammount>=max_storage and not _is_transporter_on_route():
		_spawn_transporter()

func _is_transporter_on_route() -> bool:
	return transporter!=null

func on_building_select():
	.on_building_select()

func character_arrived(character):
	.character_arrived(character)
	if character==transporter:
		transporter=null

func _produce_food(delta: float):
	if current_ammount<max_storage:
		var food_produced=production_rate*delta
		current_ammount=clamp(current_ammount+food_produced, 0, max_storage)

func _spawn_transporter():
	#var tile=_get_random_spawn_tile()
	var tile=_get_closer_spawn_tile()
	if tile:
		_spawn_transporter_instance(tile)
		current_ammount=0

func _spawn_transporter_instance(position: Vector2):
	transporter=transporter_character.instance() as Transporter
	transporter.map=map
	transporter.map_position=position
	transporter.origin_building=self
	transporter.resource_type = resource
	transporter.resource_ammount=current_ammount
	map.add_person(transporter)

# For more intelligent spawn
func _get_closer_spawn_tile():
	var building = map.resource_manager.get_target_building_for_resource(resource, map_position)
	
	if building:
		var path=map.navigation.get_road_path_between_buildings(map_position, building.map_position)
		return path[0]


func _get_random_spawn_tile():
	var road_tiles=map.navigation.get_road_tiles_next_to(map_position)
	if road_tiles.size()>0:
		# TODO: random
		return road_tiles[0]
