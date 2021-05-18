extends Character

class_name Transporter

#var resource_ammount: int
#var resource_type: int

var resource_slot:ResourceSlot

func _ready():
	assert(resource_slot != null, "Resource not set in transporter")
	var resource_ammount=origin_building.try_to_get(resource_slot.type, resource_slot.get_available_capacity())
	resource_slot.increase_quantity(resource_ammount)
	

func deliver_resource(resource:int):
	resource_slot=ResourceSlot.new(resource, Character.RESOURCE_CAPACITY)

func _on_waiting(delta: float):
	if resource_slot.is_empty():
		_return_to_origin()
	else:
		# TODO: take max distance into account
		var target=map.resource_manager.get_target_building_for_resource(resource_slot.type,resource_slot.current_quantity, origin_building.get_position())
		_go_to_building(BuildingInteraction.new(target))
	._on_waiting(delta)

func _arrived_to_destination(building:BuildingInteraction) -> void:
	if not building.is_origin:
		if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
			var stored=target_building.try_to_store(resource_slot.type, resource_slot.current_quantity)
			if stored:  # TODO: What to do if not stored?
				resource_slot.empty()
	._arrived_to_destination(building)

