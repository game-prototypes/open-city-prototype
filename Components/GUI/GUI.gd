extends CanvasLayer

signal building_selected(BuildingResource)

export var building_button: PackedScene

onready var building_buttons=$Container/BuildingButtons

func _ready():
	assert(building_button, "Building button not set in GUI")

func set_buildings(building_list):
	for building in building_list:
		add_build_button(building)

func _on_button_pressed(building: Resource):
	emit_signal("building_selected", building)

func add_build_button(building: Resource):
	add_button(building.name, building)

func add_button(label: String, param):
	var button_instance=building_button.instance() as Button
	
	button_instance.text=label
	building_buttons.add_child(button_instance)
	button_instance.connect("pressed", self, "_on_button_pressed", [param])
