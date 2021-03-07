extends Node2D

class_name Building

var map_position: Vector2
var map

func _on_building_select():
	print("BuildingSelect ", map_position)


func get_road_tiles_next_to_building() -> Array:
	return map.get_road_tiles_next_to(map_position)
