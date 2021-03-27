extends CanvasLayer

signal building_resource_selected(BuildingResource)
signal demolish_building_selected()

export var building_button: PackedScene

onready var building_buttons=$ConstructionPanel/BuildingButtons
onready var money_label=$TopContainer/MoneyLabel
onready var building_info=$BuildingInfo

func _ready():
	assert(building_button, "Building button not set in GUI")

func set_buildings(building_list):
	for building in building_list:
		add_build_button(building)
	add_button("Demolish", null, "_on_demolish_button")

func add_build_button(building: Resource):
	add_button(building.name + " ("+String(building.price)+")", building, "_on_button_pressed")

func add_button(label: String, param, callback: String):
	var button_instance=building_button.instance() as Button
	
	button_instance.text=label
	building_buttons.add_child(button_instance)
	button_instance.connect("pressed", self, callback, [param])

func show_building_info(building: Building):
	building_info.set_target_building(building)

func deselect_building():
	building_info.deselect_building()

func on_building_update():
	building_info.update_building_info()

func on_money_updated(money: int):
	money_label.text="Money: "+String(money)

func _on_button_pressed(building_resource: Resource):
	emit_signal("building_resource_selected", building_resource)

func _on_demolish_button(_param):
	emit_signal("demolish_building_selected")

