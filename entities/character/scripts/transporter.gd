extends Character

class_name Transporter

var resource_slot:ResourceSlot

enum TransporterBehavior {
	Collect,
	Deliver
}

var behavior:int

func _ready():
	assert(resource_slot != null, "Resource not set in transporter")
	
	if behavior==TransporterBehavior.Deliver:
		var resource_ammount=origin_building.try_to_get(resource_slot.type, resource_slot.get_available_capacity())
		resource_slot.increase_quantity(resource_ammount)

func deliver_resource(resource:int):
	resource_slot=ResourceSlot.new(resource, Character.RESOURCE_CAPACITY)
	behavior=TransporterBehavior.Deliver

func collect_resource(resource:int, quantity:int):
	var quantity_to_get=int(clamp(quantity, 0 , Character.RESOURCE_CAPACITY))
	resource_slot=ResourceSlot.new(resource, quantity_to_get)
	behavior=TransporterBehavior.Collect

func _on_waiting(delta: float):
	match behavior:
		TransporterBehavior.Deliver:
			_deliver_resource_behavior()
		TransporterBehavior.Collect:
			_collect_resource_behavior()
	._on_waiting(delta)

func _deliver_resource_behavior():
	if resource_slot.is_empty():
		_return_to_origin()
	else:
		# TODO: take max distance into account
		var target=map.resource_manager.get_target_building_for_resource(resource_slot.type,resource_slot.current_quantity, origin_building.get_position())
		_go_to_building(BuildingInteraction.new(target))

func _collect_resource_behavior():
	if not resource_slot.is_empty():
		_return_to_origin()
	else:
		# TODO: take max distance into account
		var target=map.resource_manager.get_target_building_with_resource(resource_slot.type,resource_slot.current_quantity, origin_building.get_position())
		_go_to_building(BuildingInteraction.new(target))


func _arrived_to_destination(building:BuildingInteraction) -> void:
	match behavior:
		TransporterBehavior.Deliver:
			_arrived_to_destination_deliver(building)
		TransporterBehavior.Collect:
			_arrived_to_destination_collect(building)
	._arrived_to_destination(building)

func _arrived_to_destination_deliver(building:BuildingInteraction) -> void:
	if not building.is_origin:
		if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
			var stored=target_building.try_to_store(resource_slot.type, resource_slot.current_quantity)
			if stored:  # TODO: What to do if not stored?
				resource_slot.empty()
	._arrived_to_destination(building)


func _arrived_to_destination_collect(building:BuildingInteraction) -> void:
	if building.is_origin:
		target_building.try_to_store(resource_slot.type, resource_slot.current_quantity)
		resource_slot.empty()
	else:
		if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
			var quantity=target_building.try_to_get(resource_slot.type, resource_slot.get_available_capacity())
			resource_slot.increase_quantity(quantity)
