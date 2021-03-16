extends Producer


export(Global.RESOURCES) var required_resource
export var required_quantity:int

var current_required_quantity: int


func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)

func _produce_resource(delta: float):
	if _has_required_quantity():
		._produce_resource(delta)


func _has_required_quantity():
	return current_required_quantity >= required_quantity

func _on_transporter_spawn():
	._on_transporter_spawn()
	current_required_quantity=0
