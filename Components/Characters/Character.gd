extends Node2D


export(float) var movement_speed=25
onready var animation: AnimatedSprite = $Animation
onready var tween: Tween = $Tween

var map: Map
var path


func _ready():
	pass # Replace with function body.


func set_path(path: Array):
	move(path)


func move(path: Array):
	if tween.is_active():
		return
	var point=path.pop_front()
	position=map.tile2pos(point)
	for point in path:
		var new_pos=map.tile2pos(point)
		var distance=position.distance_to(new_pos)
		var interpolation_time=distance/(movement_speed*10)
		
		# warning-ignore:RETURN_VALUE_DISCARDED
		tween.interpolate_property(self, "position",
			position, new_pos, interpolation_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		# warning-ignore:RETURN_VALUE_DISCARDED
		tween.start()
		yield(tween, "tween_completed")
		#map.move_item(self, point)
		#map_position=point
