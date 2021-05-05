extends Reference

var building:Building
var is_origin:bool
func _init(_building:Building, _is_origin=false):
	building=_building
	is_origin=_is_origin

func arrived_to_destination(character) -> void:
	building.on_character_arrived(character)

func try_to_store(resource: int, quantity:int)->bool:
	return building.try_to_store(resource,quantity)

func try_to_get(resource:int, quantity:int)->int:
	return building.try_to_get(resource, quantity)

func get_position()->Vector2:
	return building.map_position

func is_in_group(group:String)->bool:
	return building.is_in_group(group)
