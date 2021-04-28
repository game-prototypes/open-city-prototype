extends Character

class_name Transporter


var resource_ammount: int
var resource_type: int

func _ready():
	resource_ammount=origin_building.take_resources(Character.RESOURCE_CAPACITY)
	var target=map.resource_manager.get_target_building_for_resource(resource_type,resource_ammount, map_position)
	_set_target(target)

func arrived_to_destination():
	.arrived_to_destination()
	if target_building:
		target_building.character_arrived(self)
		if target_building==origin_building:
			_despawn()
		else:
			if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
				var stored=target_building.try_to_store(resource_type, resource_ammount)
				if stored:
					resource_ammount=0
			return_to_origin()
