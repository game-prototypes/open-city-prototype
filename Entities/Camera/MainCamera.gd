extends Camera2D

export (float) var zoom_speed=1
export (float) var camera_speed=10
export (Vector2) var zoom_constraint=Vector2(1,5)

var pan_delta=Vector2(0,0)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_action_pressed("zoom+"):
			zoom_camera(-zoom_speed)
		elif event.is_action_pressed("zoom-"):
			zoom_camera(zoom_speed)
	elif event is InputEvent:
		var horizontal_axis = Input.get_action_strength("camera_padding_right") - Input.get_action_strength("camera_padding_left")
		var vertical_axis = Input.get_action_strength("camera_padding_down")-Input.get_action_strength("camera_padding_up")
		pan_delta=Vector2(horizontal_axis, vertical_axis)


func _process(delta:float):
	if pan_delta.x!=0 || pan_delta.y!=0:
		pan_camera(pan_delta*delta)


func zoom_camera(zoom_delta: float)->void:
	var new_zoom_value=clamp(self.zoom.x+zoom_delta,zoom_constraint.x, zoom_constraint.y)
	self.zoom=Vector2(new_zoom_value,new_zoom_value)


func pan_camera(delta: Vector2)->void:
	transform=transform.translated(delta*camera_speed)
