extends Producer

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=1
export var max_required_storage:int=10
export var collector_character:PackedScene

var collector: Character
var current_required_quantity: float = 0


func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	if current_required_quantity<consumption_rate and not _is_collector_on_route():
		_spawn_collector()

func _produce_resource(delta: float):
	if _has_required_quantity(delta):
		._produce_resource(delta)
		var consumed_ammount=consumption_rate*delta
		current_required_quantity=clamp(current_required_quantity-consumed_ammount, 0, max_required_storage)
func character_arrived(character):
	.character_arrived(character)
	if character==collector:
		current_required_quantity=current_required_quantity+collector.resource_ammount
		collector=null

func _has_required_quantity(delta: float):
	return current_required_quantity >= consumption_rate*delta

func _spawn_collector():
	var tile=_get_closer_spawn_tile_for_collector()
	if tile:
		_spawn_collector_instance(tile)

func _is_collector_on_route() -> bool:
	return collector!=null

func _get_closer_spawn_tile_for_collector():
	var building = map.resource_manager.get_target_building_with_resource(required_resource,max_required_storage, map_position)
	
	if building:
		var path=map.navigation.get_road_path_between_buildings(map_position, building.map_position)
		return path[0]

func _spawn_collector_instance(position: Vector2):
	collector=collector_character.instance() as Collector
	collector.map=map
	collector.map_position=position
	collector.origin_building=self
	_on_collector_spawn()
	map.add_person(collector)

func _on_collector_spawn():
	collector.resource_type =required_resource
	collector.ammount_to_get=max_required_storage
