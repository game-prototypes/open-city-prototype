extends Node2D

class_name Building

var map_position: Vector2
var map
var stats

signal _on_building_update(delta)
signal _on_character_arrived(character)

func _ready():
	add_to_group(Global.BUILDING_GROUP)
	map=City.map

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

func _spawn_character(character, target=null)->bool:
	var character_tile
	if target==null:
		character_tile=_get_random_spawn_tile()
	else:
		character_tile=_get_closer_spawn_tile(target)
	if character_tile:
		character.setup(character_tile, self)
		map.add_person(character)
		return true
	else:
		return false

# For more intelligent spawn
func _get_closer_spawn_tile(building):
	if building:
		var path=map.navigation.get_road_path_between_buildings(map_position, building.map_position)
		return path[0]

# For more random spawn
func _get_random_spawn_tile():
	var road_tiles=map.navigation.get_road_tiles_next_to(map_position)
	if road_tiles.size()>0:
		# TODO: random?
		return road_tiles[0]
