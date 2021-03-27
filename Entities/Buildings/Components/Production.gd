extends Node

export var transporter_character:PackedScene
export var production_rate:float=1
export var max_storage:int=10
export(Global.RESOURCES) var resource

var current_ammount:float=0
var transporter: Character

var map: Map

var parent:Building

func _ready():
	parent=get_parent()
	assert(parent is Building)
	parent.register_component(Global.BUILDING_ROLES.PRODUCER, self)


func setup(_map):
	print("In component setup", _map)
	map=_map

func on_building_update(delta: float):
	_produce_resource(delta)
	if current_ammount>=max_storage and not _is_transporter_on_route():
		_spawn_transporter()

func _is_transporter_on_route() -> bool:
	return transporter!=null

func on_character_arrived(character):
	if character==transporter:
		transporter=null

func _produce_resource(delta: float):
	if current_ammount<max_storage:
		var produced_ammount=production_rate*delta
		current_ammount=clamp(current_ammount+produced_ammount, 0, max_storage)

func _spawn_transporter():
	#var tile=_get_random_spawn_tile()
	var tile=_get_closer_spawn_tile()
	if tile:
		_spawn_transporter_instance(tile)

func _spawn_transporter_instance(position: Vector2):
	transporter=transporter_character.instance() as Transporter
	transporter.map=map
	transporter.map_position=position
	transporter.origin_building=parent
	_on_transporter_spawn()
	map.add_person(transporter)

func _on_transporter_spawn():
	transporter.resource_type = resource
	transporter.resource_ammount=round(current_ammount)
	current_ammount=0

# For more intelligent spawn
func _get_closer_spawn_tile():
	print("map", map)
	var building = map.resource_manager.get_target_building_for_resource(resource,current_ammount, parent.map_position)
	
	if building:
		var path=map.navigation.get_road_path_between_buildings(parent.map_position, building.map_position)
		return path[0]


func _get_random_spawn_tile():
	var road_tiles=map.navigation.get_road_tiles_next_to(parent.map_position)
	if road_tiles.size()>0:
		# TODO: random?
		return road_tiles[0]
