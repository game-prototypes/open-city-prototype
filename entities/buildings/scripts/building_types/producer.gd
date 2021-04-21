extends Building

class_name Producer

export var transporter_character:PackedScene
export var production_rate:float=1
export var capacity:int=10
export(Global.RESOURCES) var resource

var current_ammount:float=0
var transporter: Transporter

func _ready():
	add_to_group(Global.BUILDING_ROLES.PRODUCER)

func on_building_update(delta: float):
	.on_building_update(delta)
	_produce_resource(delta)
	if _should_spawn_transporter():
		_spawn_transporter()


func character_arrived(character):
	.character_arrived(character)
	if character==transporter:
		transporter=null

func get_current_ammount()->int:
	return int(current_ammount)

func is_storage_full():
	return current_ammount>=capacity

func take_resources(max_resources:int)->int:
	var resources_to_take=int(clamp(get_current_ammount(), 0, max_resources))
	current_ammount=current_ammount - resources_to_take
	return resources_to_take

func _should_spawn_transporter():
	var resources_check=get_current_ammount()>=Character.RESOURCE_CAPACITY or is_storage_full()
	return resources_check and not _is_transporter_on_route()

func _produce_resource(delta: float):
	if current_ammount<capacity:
		var produced_ammount=production_rate*delta
		current_ammount=clamp(current_ammount+produced_ammount, 0, capacity)

func _spawn_transporter():
	var target_building = map.resource_manager.get_target_building_for_resource(resource,current_ammount, map_position)
	if target_building:
		transporter=transporter_character.instance() as Transporter
		transporter.resource_type = resource

		var spawned=_spawn_character(transporter, target_building)
		assert(spawned, "Error spawning character in producer")

func _is_transporter_on_route() -> bool:
	return transporter!=null

