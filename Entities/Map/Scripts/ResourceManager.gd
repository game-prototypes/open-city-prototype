extends Reference
class_name ResourceManager

var navigation: MapNavigation
var map

func _init(_map, mapNavigation: MapNavigation):
	navigation=mapNavigation
	map=_map

func get_target_building_for_resource(resource: int,quantity: int, from: Vector2):
	# TODO: check for space and stuff
	var buildings=map.get_buildings_of_groups(["storage"])
	var valid_buildings=[]
	for storage in buildings:
		if storage.can_store(resource, quantity):
			valid_buildings.append(storage)
	
	return navigation.get_closest_building_from_list(from, valid_buildings)
	
	
	return navigation.get_closest_building_of_groups(from, ["storage"])



func get_target_building_with_resource(resource: int, quantity: int, from: Vector2):
	var buildings=map.get_buildings_of_groups(["storage"])
	var valid_buildings=[]
	for storage in buildings:
		if storage.has_resource_quantity(resource, quantity):
			valid_buildings.append(storage)
	
	return navigation.get_closest_building_from_list(from, valid_buildings)
