extends CanvasLayer

export(PackedScene) var main_scene

func _on_new_game() -> void:
	get_tree().change_scene_to(main_scene)
