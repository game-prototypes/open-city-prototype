extends Building

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=0.02
export var max_food_storage:int=5
export var max_market_distance:int= 10
export var max_population:int=10
export var min_population:int=2

var food: float=0

var population:HousePopulation

func _ready():
	add_to_group(Global.BUILDING_ROLES.HOUSE)
	population=HousePopulation.new(max_population)

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

func get_info()->Array:
	var base_info=.get_info()
	base_info.append("Population: "+String(get_population())+"/"+String(get_max_population()))
	base_info.append("Food: "+String(get_food()))
	return base_info

func _consume_food(delta: float):
	var consumed_ammount=consumption_rate*delta*population.population
	food=clamp(food-consumed_ammount, 0, max_food_storage)

func _should_find_food()->bool:
	return food<=max_food_storage-1

func _find_market_food() -> void:
	var markets=map.navigation.get_buildings_at_distance(map_position, [Global.BUILDING_ROLES.MARKET], max_market_distance)
	
	for market in markets:
		var amount_to_get=int(max_food_storage-food)
		var available_amount=market.consume_resource(amount_to_get)
		food+=available_amount
		if food==max_food_storage:
			return

func _on_population_update() -> void:
	if !map.next_to_road(map_position):
		population.remove_all_population()
	else:
		if get_population()<min_population:
			population.increase_population(min_population)
		elif has_food():
			population.increase_population(1)
		elif population.population>min_population:
			#TODO: decrease and increase max population
			population.decrease_population(1)

func serialize() -> Dictionary:
	return Utils.merge_dict(.serialize(), {
		"population": population.population ,
		"max_population": population.max_population
	})


func load_data(data:Dictionary)->void:
	.load_data(data)
	population.population=data.get("population")
	population.max_population=data.get("max_population")
