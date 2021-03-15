extends Node

export var max_storage:int=0

var stored_resources := Dictionary()
var stored_quantity:int=0

func store(resource: int, quantity:int) -> bool:
	assert(quantity>=0, "Invalid negative quantity to store")
	if not can_store_quantity(quantity):
		return false
	var current_resource_quantity=get_resource_quantity(resource)
	stored_resources[resource]=current_resource_quantity+quantity
	stored_quantity=stored_quantity+quantity
	return true

func remove(resource: int, quantity:int) -> void:
	var current_resource_quantity=get_resource_quantity(resource)
	assert(quantity<=current_resource_quantity, "Not enough resources to remove")
	stored_resources[resource]=current_resource_quantity-quantity
	stored_quantity=stored_quantity-quantity

func can_store_quantity(quantity: int) -> bool:
	 return stored_quantity+quantity <= max_storage

func get_resource_quantity(resource: int) -> int:
	return stored_resources.get(resource, 0)
