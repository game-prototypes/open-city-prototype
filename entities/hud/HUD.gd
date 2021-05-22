extends CanvasLayer

signal building_resource_selected(BuildingResource)
signal demolish_building_selected()
signal save()

export var building_button: PackedScene

onready var building_buttons=$ConstructionPanel/BuildingButtons
onready var money_label=$TopContainer/MoneyLabel
onready var population_label=$TopContainer/PopulationLabel
onready var building_info=$BuildingInfo

export(NodePath) var version_label_path
onready var version_label:Label = get_node(version_label_path)


func _ready():
	assert(building_button, "Building button not set in GUI")
	var version=ProjectSettings.get_setting("application/config/version")
	version_label.text="v"+version

func _process(_delta: float):
	building_info.update_building_info()

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

func on_money_updated(money: int):
	money_label.text="Money: "+String(money)

func on_population_updated(population: int):
	population_label.text="Population: "+String(population)


func _on_button_pressed(building_resource: Resource):
	emit_signal("building_resource_selected", building_resource)

func _on_demolish_button(_param):
	emit_signal("demolish_building_selected")

func _on_save():
	emit_signal("save")
