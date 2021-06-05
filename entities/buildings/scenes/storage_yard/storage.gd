extends Reference
class_name Storage

var max_storage:int=0

var stored_resources := Dictionary()
var stored_quantity:int=0

func _init(_max_storage:int):
	max_storage=_max_storage

func store(resource: int, quantity:int) -> bool:
	Log.info("Store", resource, quantity)
	assert(quantity>=0, "Invalid negative quantity to store")
	if not can_store_quantity(quantity):
		return false
	var current_resource_quantity=get_resource_quantity(resource)
	stored_resources[resource]=current_resource_quantity+quantity
	stored_quantity=stored_quantity+quantity
	return true

func remove(resource: int, quantity:int) -> void:
	Log.info("Remove", resource, quantity)
	var current_resource_quantity=get_resource_quantity(resource)
	assert(quantity<=current_resource_quantity, "Not enough resources to remove")
	stored_resources[resource]=current_resource_quantity-quantity
	stored_quantity=stored_quantity-quantity
	assert(stored_quantity>=0, "Stored quantity less than 0")

func can_store_quantity(quantity: int) -> bool:
	 return stored_quantity+quantity <= max_storage

func get_resource_quantity(resource: int) -> int:
	return stored_resources.get(resource, 0)

func get_occupied_space() -> int:
	return stored_quantity

func is_empty()->bool:
	return stored_quantity==0

func serialize() -> Dictionary:
	return {
		"stored_resources":stored_resources,
		"max_storage":max_storage,
		"stored_quantity": stored_quantity
	}
	
func load_data(data:Dictionary)->void:
	max_storage = data.get("max_storage")
	stored_quantity = data.get("stored_quantity")
	
	var raw_stored_resources = data.get("stored_resources")
	for res in raw_stored_resources:
		var quantity=raw_stored_resources[res]
		stored_resources[int(res)] = quantity
