class_name ResourceManager

var navigation: MapNavigation

func _init(mapNavigation: MapNavigation):
	navigation=mapNavigation


func get_target_building_for_resource(resource: int, from: Vector2):
	return navigation.get_closest_building_of_group(from, "storage")
