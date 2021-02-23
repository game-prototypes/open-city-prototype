extends CanvasLayer

signal press_button(string)

func _on_button_pressed(button: String):
	emit_signal("press_button", button)
	print("press ", button)
