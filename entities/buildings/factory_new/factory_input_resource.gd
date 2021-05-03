extends Reference

var required_quantity: int
var current_quantity: int
var resource:int

func _init(_resource:int, _quantity:int):
	resource=_resource
	required_quantity=_quantity

func add_resource_quantity(quantity: int):
	current_quantity+=quantity

func has_enough_quantity()->bool:
	return current_quantity>=required_quantity

func consume_resource()->void:
	assert(has_enough_quantity(), "Factory consume resource, not enough quantity")
	current_quantity-=required_quantity

