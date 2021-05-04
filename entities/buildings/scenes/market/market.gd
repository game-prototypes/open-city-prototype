extends Building

class_name Market

export(Global.RESOURCES) var required_resource:int
export var max_resource_quantity:int=10
export var collector_character:PackedScene

var collector: Collector
var current_quantity: float = 0

func _ready():
	add_to_group(Global.BUILDING_ROLES.MARKET)

func get_resource_quantity()->int:
	return int(current_quantity)

func consume_resource(amount:int)->int:
	var amount_to_get=min(current_quantity, amount)
	current_quantity-=amount_to_get
	return amount_to_get

func try_to_store(resource_type:int, resource_ammount:int)->bool:
	if resource_type!=required_resource:
		return false
	if resource_ammount+current_quantity<=max_resource_quantity:
		current_quantity+=resource_ammount
		return true
	return false

func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	if _should_spawn_collector():
		_spawn_collector()

func on_character_arrived(character):
	.on_character_arrived(character)
	if character==collector:
		current_quantity=current_quantity+collector.resource_ammount
		collector=null

func get_available_capacity() -> int:
	return int(ceil(max_resource_quantity-current_quantity))

func has_required_resource() -> bool:
	return current_quantity > 0

func get_info()->Array:
	var base_info=.get_info()
	var resource_text=String(current_quantity)+"/"+String(max_resource_quantity)
	var extra_info= Global.resource_names[required_resource]+": "+resource_text
	base_info.append(extra_info)
	return base_info

func _ammount_to_collect()->int:
	return int(clamp(get_available_capacity(), 0, Character.RESOURCE_CAPACITY))

func _should_spawn_collector() -> bool:
	var available_capacity=get_available_capacity()
	var resources_check = available_capacity>=Character.RESOURCE_CAPACITY or not has_required_resource()
	return resources_check and not _is_collector_on_route()

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
