extends Consumer

func get_resource_quantity()->int:
	return int(current_required_quantity)


func consume_resource(ammount:int)->void:
	assert(current_required_quantity>ammount)
	current_required_quantity=current_required_quantity-ammount
