extends MarginContainer


onready var container=$VBoxContainer

var target_building

func set_target_building(building: Building):
	target_building=building
	update_building_info()

func deselect_building():
	remove_labels()
	target_building=null

func update_building_info():
	if not target_building:
		return
	remove_labels() # TODO: update labels instead of removing and re-creating
	if not is_instance_valid(target_building):
		return
	var building_info=target_building.get_info()
	for text_row in building_info:
		add_label(text_row)

func add_label(text: String):
	var label=Label.new()
	label.text=text
	
	container.add_child(label)


func remove_labels():
	var labels=container.get_children()
	for label in labels:
		label.queue_free()
