extends Node2D

class_name Building

func _on_building_select():
	print("BuildingSelect")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			print("Building clicked")
			get_tree().set_input_as_handled()
