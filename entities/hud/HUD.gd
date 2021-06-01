extends CanvasLayer

signal building_resource_selected(BuildingResource)
signal demolish_building_selected()
signal save()

export var building_button: PackedScene

onready var building_buttons=$ConstructionPanel/BuildingButtons
onready var money_label=$TopContainer/MoneyLabel
onready var population_label=$TopContainer/PopulationLabel
onready var building_info=$BuildingInfo


func _ready():
	assert(building_button, "Building button not set in GUI")
	var building_list=Store.get_building_resources()
	_set_buildings(building_list)

func _process(_delta: float):
	building_info.update_building_info()

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

func _on_build_button_pressed(building_name: String):
	var resource=Store.get_building_resource(building_name)
	emit_signal("building_resource_selected", resource)

func _on_demolish_button(_param):
	emit_signal("demolish_building_selected")

func _on_save():
	emit_signal("save")

func _set_buildings(building_list):
	for building in building_list:
		_add_build_button(building)
	add_button("Demolish", null, "_on_demolish_button")

func _add_build_button(building: Resource):
	add_button(building.name + " ("+String(building.price)+")", building.name, "_on_build_button_pressed")
