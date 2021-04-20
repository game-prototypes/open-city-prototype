extends Building

class_name Consumer

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=1
export var max_required_storage:int=10
export var collector_character:PackedScene

var collector: Character
var current_required_quantity: float = 0

func _ready():
	add_to_group(Global.BUILDING_ROLES.CONSUMER)


func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	_consume_resource(delta)
	if (current_required_quantity<consumption_rate or current_required_quantity==0) and not _is_collector_on_route():
		_spawn_collector()

func _consume_resource(delta: float):
	if _has_required_quantity(delta):
		var consumed_ammount=consumption_rate*delta
		current_required_quantity=clamp(current_required_quantity-consumed_ammount, 0, max_required_storage)

func character_arrived(character):
	if character==collector:
		current_required_quantity=current_required_quantity+collector.resource_ammount
		collector=null

func _has_required_quantity(delta: float):
	return current_required_quantity >= consumption_rate*delta

func _spawn_collector():
	var target_building = map.resource_manager.get_target_building_with_resource(required_resource,max_required_storage, map_position)
	if target_building:
		collector=collector_character.instance() as Collector
		collector.resource_type =required_resource
		collector.ammount_to_get=max_required_storage
		var spawned=_spawn_character(collector, target_building)
		assert(spawned, "Collector not spawned in consumer building")

func _is_collector_on_route() -> bool:
	return collector!=null
