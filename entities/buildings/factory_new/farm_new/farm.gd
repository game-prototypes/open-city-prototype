extends Factory


export(Global.RESOURCES) var production_resource
export var production_quantity:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_output_resource(production_resource, production_quantity)
