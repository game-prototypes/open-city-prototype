extends Building

class_name Consumer

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=1
export var max_required_storage:int=10
export var collector_character:PackedScene

var collector: Collector
var current_required_quantity: float = 0

func _ready():
	add_to_group(Global.BUILDING_ROLES.CONSUMER)

func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	_consume_resource(delta)
	if should_spawn_collector():
		_spawn_collector()

func character_arrived(character):
	if character==collector:
		current_required_quantity=current_required_quantity+collector.resource_ammount
		collector=null

func get_available_capacity() -> int:
	return int(ceil(max_required_storage-current_required_quantity))

func should_spawn_collector() -> bool:
	var available_capacity=get_available_capacity()
	var resources_check = available_capacity>=Character.RESOURCE_CAPACITY or not has_required_resource()
	return resources_check and not _is_collector_on_route()

func has_required_resource() -> bool:
	return current_required_quantity > 0

func _ammount_to_collect()->int:
	return int(clamp(get_available_capacity(), 0, Character.RESOURCE_CAPACITY))

func _spawn_collector():
	var resources_to_get=_ammount_to_collect()
	var target_building = map.resource_manager.get_target_building_with_resource(required_resource,resources_to_get, map_position)
	if target_building:
		collector=collector_character.instance() as Collector
		collector.resource_type =required_resource
		collector.set_ammount_to_get(resources_to_get)
		var spawned=_spawn_character(collector, target_building)
		assert(spawned, "Collector not spawned in consumer building")

func _is_collector_on_route() -> bool:
	return collector!=null

func _consume_resource(delta: float):
	var consumed_ammount=consumption_rate*delta
	current_required_quantity=clamp(current_required_quantity-consumed_ammount, 0, max_required_storage)
