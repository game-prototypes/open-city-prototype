extends Reference

# Defines a single slot of a certain resource quantity
class_name ResourceSlot


var type:int
var current_quantity:int
var capacity:int

func _init(resource, _capacity, quantity=0):
	type=resource
	current_quantity=quantity
	capacity=_capacity


func get_available_capacity()->int:
	return capacity-current_quantity

func increase_quantity(quantity:int)->void:
	current_quantity+=quantity
	assert(current_quantity<=capacity, "Capacity exceeded in resource slot")

func is_empty()->bool:
	return current_quantity==0

func empty()->void:
	current_quantity=0
