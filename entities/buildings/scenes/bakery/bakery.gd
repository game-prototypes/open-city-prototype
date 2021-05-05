extends Factory

export(Global.RESOURCES) var consumed_resource:int
export var consumption_quantity:int

export(Global.RESOURCES) var production_resource:int
export var production_quantity:int

func _ready() -> void:
	_add_output_resource(production_resource, production_quantity)
	_add_input_resource(consumed_resource, consumption_quantity)
