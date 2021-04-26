extends Consumer

class_name Market

func _ready():
	add_to_group(Global.BUILDING_ROLES.MARKET)

func get_resource_quantity()->int:
	return int(current_required_quantity)

func consume_resource(amount:int)->int:
	var amount_to_get=min(current_required_quantity, amount)
	current_required_quantity-=amount_to_get
	return amount_to_get
