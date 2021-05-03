extends Workplace

class_name Factory

const FactoryInputResource=preload("./factory_input_resource.gd")
const FactoryOutputResource=preload("./factory_output_resource.gd")

export var production_time:int=5 # seconds to produce
export var collector_character:PackedScene
export var transporter_character:PackedScene

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

func character_arrived(character):
	.character_arrived(character)
	if character==_transporter:
		_transporter=null
	if character==_collector:
		_collector=null

func get_production_percentage()->int:
	return int((production_time-time_left)/production_time*100)

func take_resources(resource:int, max_resources:int)->int:
	print("resource in take", resource)
	var factory_resource=_get_output_resource(resource)
	var resources_to_take=factory_resource.take_resource(max_resources)
	print("resources to take", max_resources)
	return resources_to_take

func get_info()->Array:
	var info=.get_info()
	var production_text="Production:"+String(get_production_percentage())+"%"
	info.append(production_text)
	info.append("Can produce?"+String(_can_produce()))
	return info

func _try_to_spawn_transporter():
	print("try to spawn")
	if _is_transporter_on_route():
		return
	for resource in output_resources:
		if not resource.is_empty():
			print("Reousrce not empty")
			var target_building = map.resource_manager.get_target_building_for_resource(resource.resource,resource.current_quantity, map_position)
			if target_building:
				_transporter=transporter_character.instance()
				_transporter.resource_type = resource.resource

				var spawned=_spawn_character(_transporter, target_building)
				assert(spawned, "Error spawning transporter in factory")
				return


func _should_spawn_collector():
	pass

func _spawn_transporter():
	print("spawn_transporter")

func _spawn_collector():
	pass

func _can_produce() -> bool:
	for input_resource in input_resources:
		if not input_resource.has_enough_quantity():
			return false
	
	for output_resource in output_resources:
		if not output_resource.is_empty():
			return false
	return true

func _produce_resources():
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
		print("reosurce found", res.resource)
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
