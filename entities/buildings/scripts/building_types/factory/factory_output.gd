extends Reference

var production_quantity: int
var current_quantity: int
var resource:int

func _init(_resource:int, _quantity:int):
	resource=_resource
	production_quantity=_quantity

func is_empty()->bool:
	return current_quantity==0

func take_resource(max_quantity:int)->int:
	var resources_to_take=min(max_quantity, current_quantity)
	current_quantity-=resources_to_take
	return resources_to_take

func produce_resource()->void:
	assert(is_empty(), "Factory produce resource, not empty")
	current_quantity=production_quantity


func serialize()->Dictionary:
	return {
		"production_quantity":production_quantity,
		"current_quantity":current_quantity,
		"resource":resource
	}

func load_data(data:Dictionary)->void:
	production_quantity=data.get("production_quantity")
	current_quantity=data.get("current_quantity")
