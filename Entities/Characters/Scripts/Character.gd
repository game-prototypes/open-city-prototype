extends Node2D

class_name Character

export var type: String
export(float) var movement_speed=25
onready var animation: AnimatedSprite = $Animation
onready var tween: Tween = $Tween

var map: Map
var _path: Array

var map_position:Vector2

func _ready():
	assert(type, "Character type not set")
	position=map.tile2pos(map_position)

func arrived_to_destination():
	pass

func set_path(path: Array):
	_path=path
	if path.size()>0:
		_move(path)

func _move(path: Array):
	if tween.is_active():
		print("Tween is active?")
		return
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
