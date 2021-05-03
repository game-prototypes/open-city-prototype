extends Factory

export(Global.RESOURCES) var production_resource
export var production_quantity:int

func _ready() -> void:
	_add_output_resource(production_resource, production_quantity)
