extends Node2D

class_name Building

var map_position: Vector2
var map
var stats

func _ready():
	add_to_group(Global.BUILDING_GROUP)

func on_building_select():
	pass

func on_building_update(_delta: float):
	pass

func character_arrived(_character) -> void:
	pass

func get_occupied_tiles() -> Array:
	var area:Vector2=stats.area
	var result=[]
	for i in range(map_position.x,map_position.x+area.x):
		for j in range(map_position.y, map_position.y+area.y):
			result.append(Vector2(i,j))
	return result
