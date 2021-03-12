extends Character

class_name Transporter

var target_building_group: String

var target_building: Building
var origin_building: Building

var resource_ammount: int
var resource_type: int

func _ready():
	assert(target_building_group, "Target building group is not set")
	target_building=map.navigation.get_closest_building_of_type(map_position, target_building_group)
	_set_target(target_building)

func arrived_to_destination():
	.arrived_to_destination()
	if target_building:
		target_building.character_arrived(self)
		if target_building==origin_building:
			_despawn()
		else:
			return_to_origin()

func return_to_origin():
	_set_target(origin_building)

func _set_target(target:Building):
	target_building=target
	if target_building:
		var new_path=map.navigation.get_road_path_to_building(map_position, target_building.map_position)
		set_path(new_path)

func _despawn():
	queue_free()
