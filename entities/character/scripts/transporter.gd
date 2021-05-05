extends Character

class_name Transporter

var resource_ammount: int
var resource_type: int

func _ready():
	var target=map.resource_manager.get_target_building_for_resource(resource_type,resource_ammount, origin_building.get_position())
	resource_ammount=origin_building.try_to_get(resource_type, Character.RESOURCE_CAPACITY)	
	_set_target(BuildingInteraction.new(target))

func arrived_to_destination(building:BuildingInteraction) -> void:
	if not building.is_origin:
		if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
			var stored=target_building.try_to_store(resource_type, resource_ammount)
			if stored:  # TODO: What to do if not stored?
				resource_ammount=0
		return_to_origin()
	.arrived_to_destination(building)
	
