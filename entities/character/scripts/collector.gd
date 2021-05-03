extends Character

class_name Collector

var ammount_to_get: int
var resource_ammount: int
var resource_type: int

func _ready():
	var target=map.resource_manager.get_target_building_with_resource(resource_type, ammount_to_get, map_position)
	_set_target(target)

func set_ammount_to_get(ammount: int)->void:
	ammount_to_get=int(clamp(ammount, 0 , Character.RESOURCE_CAPACITY))

func arrived_to_destination():
	.arrived_to_destination()
	if target_building:
		target_building.character_arrived(self)
		if target_building==origin_building:
			origin_building.save_resources(resource_type, resource_ammount)
			_despawn()
		else:
			if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
				var ammount=target_building.try_to_get(resource_type, ammount_to_get)
				resource_ammount=ammount
			return_to_origin()
