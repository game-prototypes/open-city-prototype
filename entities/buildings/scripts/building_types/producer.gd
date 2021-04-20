extends Building

class_name Producer

export var transporter_character:PackedScene
export var production_rate:float=1
export var max_storage:int=10
export(Global.RESOURCES) var resource

var current_ammount:float=0
var transporter: Character

func _ready():
	add_to_group(Global.BUILDING_ROLES.PRODUCER)

func on_building_update(delta: float):
	.on_building_update(delta)
	_produce_resource(delta)
	if current_ammount>=max_storage and not _is_transporter_on_route():
		_spawn_transporter()


func character_arrived(character):
	.character_arrived(character)
	if character==transporter:
		transporter=null

func get_current_ammount()->int:
	return int(current_ammount)

func _produce_resource(delta: float):
	if current_ammount<max_storage:
		var produced_ammount=production_rate*delta
		current_ammount=clamp(current_ammount+produced_ammount, 0, max_storage)

func _spawn_transporter():
	var target_building = map.resource_manager.get_target_building_for_resource(resource,current_ammount, map_position)
	if target_building:
		transporter=transporter_character.instance() as Transporter
		transporter.resource_type = resource
		transporter.resource_ammount=round(current_ammount)
		current_ammount=0
		var spawned=_spawn_character(transporter, target_building)
		assert(spawned, "Error spawning character in producer")

func _is_transporter_on_route() -> bool:
	return transporter!=null

