extends Node2D

class_name Character

export(float) var movement_speed=25
onready var animation: AnimatedSprite = $Animation
onready var tween: Tween = $Tween

var origin_building: Building
var target_building: Building

var map: Map
var _path: Array

var map_position:Vector2

func _ready():
	position=map.tile2pos(map_position)

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
	var point=path.pop_front()
	position=map.tile2pos(point)
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
	queue_free()
