extends Workplace

class_name Factory

const FactoryInputResource=preload("./factory_input.gd")
const FactoryOutputResource=preload("./factory_output.gd")

export var production_time:int=5 # seconds to produce
export var collector_character:PackedScene
export var transporter_character:PackedScene
# TODO: export var max_storage=10

var input_resources=[]
var output_resources=[]
var time_left:float=0

signal factory_production_finished

var _transporter
var _collector

func _ready() -> void:
	time_left=production_time

func on_building_update(delta: float):
	.on_building_update(delta)
	if _can_produce():
		var production_delta=delta*get_workers_rate()
		time_left=max(time_left-production_delta, 0)
		if time_left==0:
			_produce_resources()
			time_left=production_time
	else:
		_try_to_spawn_transporter()
		_try_to_spawn_collector()

func on_character_arrived(character):
	.on_character_arrived(character)
	if character==_transporter:
		_transporter=null
	if character==_collector:
		_collector=null

func get_production_percentage()->int:
	return int((production_time-time_left)/production_time*100)

func try_to_get(resource:int, max_resources:int)->int:
	var factory_resource=_get_output_resource(resource)
	var resources_to_take=factory_resource.take_resource(max_resources)
	return resources_to_take

func try_to_store(resource:int, quantity:int)->bool:
	var factory_resource=_get_input_resource(resource)
	factory_resource.add_resource_quantity(quantity)
	# TODO: check space
	return true

func get_info()->Array:
	var info=.get_info()
	var production_text="Production:"+String(get_production_percentage())+"%"
	info.append(production_text)
	for res in input_resources:
		var resource_text=Global.resource_names[res.resource]+": "+String(res.current_quantity)
		info.append("->"+resource_text)
	
	for res in output_resources:
		var resource_text=Global.resource_names[res.resource]+": "+String(res.current_quantity)
		info.append("<-"+resource_text)
	return info

func serialize()->Dictionary:
	return Utils.merge_dict(.serialize(), {
		"input_resources":Serializer.serialize_array(input_resources),
		"output_resources":Serializer.serialize_array(output_resources),
		"time_left":time_left
	})

func _try_to_spawn_transporter():
	if _is_transporter_on_route():
		return
	for resource in output_resources:
		if not resource.is_empty():
			var target_building = map.resource_manager.get_target_building_for_resource(resource.resource,resource.current_quantity, map_position)
			if target_building:
				_transporter=transporter_character.instance()
				_transporter.deliver_resource(resource.resource)
				Log.info(name+" spawn transporter")
				var spawned=_spawn_character(_transporter, target_building)
				assert(spawned, "Error spawning transporter in factory")
				return


func _try_to_spawn_collector():
	if _is_collector_on_route():
		return
	for resource in input_resources:
		if not resource.has_enough_quantity():
			var required_quantity=resource.get_required_quantity()
			# TODO: accept buildings even if not enough quantity is available
			var target_building = map.resource_manager.get_target_building_with_resource(resource.resource,required_quantity, map_position)
			if target_building:
				_collector=collector_character.instance() as Transporter
				_collector.collect_resource(resource.resource, required_quantity)
				Log.info(name+" spawn collector")
				var spawned=_spawn_character(_collector, target_building)
				assert(spawned, "Collector not spawned in factory")

func _has_required_resources() -> bool:
	for input_resource in input_resources:
		if not input_resource.has_enough_quantity():
			return false
	return true

func _can_store_production() -> bool:
	for output_resource in output_resources:
		if not output_resource.is_empty():
			return false
	return true

func _can_produce() -> bool:
	return _has_required_resources() and _can_store_production()

func _produce_resources():
	Log.info(name+" production finished")
	for input_resource in input_resources:
		input_resource.consume_resource()
	
	for output_resource in output_resources:
		output_resource.produce_resource()
	
	emit_signal("factory_production_finished")

func _get_input_resource(resource:int):
	for res in input_resources:
		if res.resource==resource:
			return res
	assert(false, "Resource not found in factory, _get_input_resource")

func _get_output_resource(resource:int):
	for res in output_resources:
		if res.resource==resource:
			return res
	assert(false, "Resource not found in factory, _get_output_resource")
	
func _add_input_resource(resource:int, quantity:int):
	var input_resource=FactoryInputResource.new(resource, quantity)
	input_resources.append(input_resource)
	
func _add_output_resource(resource:int, quantity:int):
	var output_resource=FactoryOutputResource.new(resource, quantity)
	output_resources.append(output_resource)

func _is_transporter_on_route() -> bool:
	return _transporter!=null

func _is_collector_on_route() -> bool:
	return _collector!=null
