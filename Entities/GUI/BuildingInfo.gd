extends MarginContainer


onready var container=$VBoxContainer

var target_building

func set_target_building(building: Building):
	target_building=building
	update_building_info()

func update_building_info():
	if not target_building:
		return
	remove_labels() # TODO: update labels instead of removing and re-creating
	add_label(target_building.stats.name)
	if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
		var label_text=String(target_building.storage.get_occupied_space())+"/"+String(target_building.storage.max_storage)
		add_label(label_text)
		var resources=target_building.storage.stored_resources
		for resource in resources:
			var resource_text=Global.resource_names[resource]+": "+String(resources[resource])
			add_label(resource_text)
	if target_building.is_in_group(Global.BUILDING_ROLES.PRODUCER):
		#print(target_building.get_component("production"))
		var label_text=Global.resource_names[target_building.resource]+": "+String(target_building.current_ammount)
		add_label(label_text)
	if target_building.is_in_group(Global.BUILDING_ROLES.CONSUMER):
		var label_text="Require: "+Global.resource_names[target_building.required_resource]+": "+String(target_building.current_required_quantity)
		add_label(label_text)

func add_label(text: String):
	var label=Label.new()
	label.text=text
	
	container.add_child(label)


func remove_labels():
	var labels=container.get_children()
	for label in labels:
		label.queue_free()
