extends MarginContainer


onready var container=$VBoxContainer

func add_building_info(building: Building):
	add_label(building.stats.name)
	if building.is_in_group(Global.STORAGE_GROUP):
		var label_text=String(building.storage.get_occupied_space())+"/"+String(building.storage.max_storage)
		add_label(label_text)


func add_label(text: String):
	var label=Label.new()
	label.text=text
	
	container.add_child(label)


func remove_labels():
	var labels=container.get_children()
	for label in labels:
		label.queue_free()
