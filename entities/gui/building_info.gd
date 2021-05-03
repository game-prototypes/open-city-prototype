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
	
	
func update_building_info2():
	if not target_building:
		return
	remove_labels() # TODO: update labels instead of removing and re-creating
	if not is_instance_valid(target_building):
		return
	
	add_label(target_building.stats.name)
	if target_building.is_in_group(Global.BUILDING_ROLES.STORAGE):
		var label_text=String(target_building.storage.get_occupied_space())+"/"+String(target_building.storage.max_storage)
		add_label(label_text)
		var resources=target_building.storage.stored_resources
		for resource in resources:
			var resource_text=Global.resource_names[resource]+": "+String(resources[resource])
			add_label(resource_text)
	if target_building.is_in_group(Global.BUILDING_ROLES.PRODUCER):
		var label_text=Global.resource_names[target_building.resource]+": "+String(target_building.get_current_ammount())
		var workers_text="Workers: "+String(target_building.get_workers())+"/"+String(target_building.get_max_workers())
		add_label(label_text)
		add_label(workers_text)
	if target_building.is_in_group(Global.BUILDING_ROLES.CONSUMER):
		var label_text="Require "+Global.resource_names[target_building.required_resource]+": "+String(target_building.current_required_quantity)
		add_label(label_text)
	if target_building.is_in_group(Global.BUILDING_ROLES.HOUSE):
		var food_label_text="Food: "+String(target_building.get_food())
		var population_label_text="Population: "+String(target_building.get_population())+"/"+String(target_building.get_max_population())
		add_label(food_label_text)
		add_label(population_label_text)


func add_label(text: String):
	var label=Label.new()
	label.text=text
	
	container.add_child(label)


func remove_labels():
	var labels=container.get_children()
	for label in labels:
		label.queue_free()
