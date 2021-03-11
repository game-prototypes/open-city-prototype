extends Character

export var target_building_group: String

var target_building: Building
var origin_building: Building

func _ready():
	assert(target_building_group, "Target building group is not set")
	_set_target()


func _set_target():
	print("Set target ",target_building_group, map_position)
	target_building=map.navigation.get_closest_building_of_type(map_position, target_building_group)
	
	if target_building:
		var new_path=map.navigation.get_road_path_to_building(map_position, target_building.map_position)
		set_path(new_path)


func arrived_to_destination():
	.arrived_to_destination()
	if target_building:
		target_building.character_arrived(self)
