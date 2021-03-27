extends Node2D

class_name Building

var map_position: Vector2
var map
var stats

var components=Dictionary()

signal _on_building_update(delta)
signal _on_character_arrived(character)

func _ready():
	print("map in building", map)
	add_to_group(Global.BUILDING_GROUP)
	for component_name in components:
		var component=components[component_name]
		component.setup(map)
		connect("_on_building_update", component, "on_building_update")
		connect("_on_character_arrived", component, "on_character_arrived")

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

func register_component(role, component):
	components[role]=component
	add_to_group(role)

func get_component(name):
	return components.get(name)
