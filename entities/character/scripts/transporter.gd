extends Character

class_name Transporter

var resource_ammount: int
var resource_type: int

func _ready():
	var target=map.resource_manager.get_target_building_for_resource(resource_type,resource_ammount, origin_building.map_position)
	_set_target(target)

func on_departure(origin_building:BuildingInteraction)->void:
	resource_ammount=origin_building.try_to_get(resource_type, Character.RESOURCE_CAPACITY)

func arrived_to_destination(building_interaction:BuildingInteraction, is_origin:bool):
	if not is_origin:
		if building_interaction.is_in_group(Global.BUILDING_ROLES.STORAGE):
			var stored=building_interaction.try_to_store(resource_type, resource_ammount)
			if stored:  # TODO: What to do if not stored?
				resource_ammount=0
			return_to_origin()
	.arrived_to_destination(building_interaction, is_origin)
	
