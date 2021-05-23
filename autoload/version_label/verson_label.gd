extends CanvasLayer

export(NodePath) var version_label_path
onready var version_label:Label = get_node(version_label_path)

func _ready():
	var version=ProjectSettings.get_setting("application/config/version")
	version_label.text="v"+version
