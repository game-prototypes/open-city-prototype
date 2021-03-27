extends Node2D

class_name Building

var map_position: Vector2
var map
var stats

signal _on_building_update(delta)
signal _on_character_arrived(character)

func _ready():
	add_to_group(Global.BUILDING_GROUP)

func on_building_select():
	pass

func on_building_update(delta: float):
	emit_signal("_on_building_update", delta)

func character_arrived(character) -> void:
	emit_signal("_on_character_arrived", character)

func get_occupied_tiles() -> Array:
	var area:Vector2=stats.area
	var result=[]
	for i in range(map_position.x,map_position.x+area.x):
		for j in range(map_position.y, map_position.y+area.y):
			result.append(Vector2(i,j))
	return result
