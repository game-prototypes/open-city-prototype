extends Building

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=1
export var max_food_storage:int=5
export var max_market_distance:int= 10
export var max_population:int=10

var food: float=0

var population:HousePopulation

func _ready():
	add_to_group(Global.BUILDING_ROLES.HOUSE)
	population=HousePopulation.new(max_population)
	population.increase_population(5)
	
func _exit_tree():
	population.remove_all_population()

func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	_consume_food(delta)
	if _should_find_food():
		_find_market_food()

func get_population():
	return population.population
	
func get_max_population():
	return population.max_population

func get_food()->int:
	return int(food)

func has_food() -> bool:
	return get_food()>0

func _consume_food(delta: float):
	var consumed_ammount=consumption_rate*delta
	food=clamp(food-consumed_ammount, 0, max_food_storage)

func _should_find_food()->bool:
	return food<=max_food_storage-1

func _find_market_food():
	var markets=map.navigation.get_buildings_at_distance(map_position, [Global.BUILDING_ROLES.MARKET], max_market_distance)
	# TODO: look in all markets
	if markets.size()>0:
		var market=markets[0] as Market
		var amount_to_get=int(max_food_storage-food)
		var available_amount=market.consume_resource(amount_to_get)
		food+=available_amount


func _on_population_update() -> void:
	if has_food():
		population.increase_population(1)
	elif population.max_population>1:
		population.decrease_max_population(1)
