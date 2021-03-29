extends Building

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=1
export var max_required_storage:int=5
export var max_market_distance:int= 10

var current_required_quantity: float = 0


func _ready():
	CityResources.increase_population(10)
	
	
func _exit_tree():
	CityResources.decrease_population(10)

func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	_consume_resource(delta)
	if (current_required_quantity<consumption_rate or current_required_quantity==0):
		_find_market_food()

func _consume_resource(delta: float):
	if _has_required_quantity(delta):
		var consumed_ammount=consumption_rate*delta
		current_required_quantity=clamp(current_required_quantity-consumed_ammount, 0, max_required_storage)

func _has_required_quantity(delta: float):
	return current_required_quantity >= consumption_rate*delta


func _find_market_food():
	var markets=map.navigation.get_buildings_at_distance(map_position, [Global.BUILDING_ROLES.MARKET], max_market_distance)
	# TODO: consume food from market
