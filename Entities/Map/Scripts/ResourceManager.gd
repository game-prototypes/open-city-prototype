class_name ResourceManager

var navigation: MapNavigation

func _init(mapNavigation: MapNavigation):
	navigation=mapNavigation

func get_target_building_for_resource(resource: int, from: Vector2):
	# TODO: check for space and stuff
	return navigation.get_closest_building_of_groups(from, ["storage"])



func get_target_building_with_resource(resource: int, from: Vector2):
	# TODO: check for reosurce and stuff
	return navigation.get_closest_building_of_groups(from, ["storage"])
