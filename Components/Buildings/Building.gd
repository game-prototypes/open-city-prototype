extends Node2D

class_name Building

var map_position: Vector2
var map

func _on_building_select():
	print("BuildingSelect ", map_position)
