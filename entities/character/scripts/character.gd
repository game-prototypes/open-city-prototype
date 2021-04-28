extends Node2D

class_name Character

const RESOURCE_CAPACITY=5
const DESPAWN_TIME=0.5

export(float) var movement_speed=25


onready var animation: AnimatedSprite = $Animation
onready var tween: Tween = $Tween
# TODO: use a state machine instead of changing target_building
var origin_building: Building
var target_building: Building

var map
var _path: Array

var map_position:Vector2

func _ready():
	map=City.map
	assert(map_position and origin_building, "Character not set")
	position=map.tile2pos(map_position)

func setup(_map_position:Vector2, _origin_building: Building):
	map_position=_map_position
	origin_building=_origin_building

func arrived_to_destination():
	pass

func set_path(path: Array):
	_path=path
	if path.size()>0:
		_move(path)

func return_to_origin():
	_set_target(origin_building)

func _move(path: Array):
	assert(tween.is_active()==false, "Move with already active tween")
	var first_point=path.pop_front()
	position=map.tile2pos(first_point)
	for point in path:
		var new_pos=map.tile2pos(point)
		var distance=position.distance_to(new_pos)
		var interpolation_time=distance/(movement_speed*10)
		
		tween.interpolate_property(self, "position",
			position, new_pos, interpolation_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		map_position=point
	tween.stop_all()
	arrived_to_destination()


func _set_target(target:Building):
	target_building=target
	if target_building:
		var new_path=map.navigation.get_road_path_to_building(map_position, target_building.map_position)
		set_path(new_path)

func _despawn():
	print("despawn before")
	yield(get_tree().create_timer(DESPAWN_TIME), "timeout")
	print("despawn after")
	queue_free()
