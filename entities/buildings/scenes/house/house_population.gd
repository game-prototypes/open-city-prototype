extends Reference

class_name HousePopulation

var max_population:int
var population:int

func _init(_max_population: int) -> void:
	max_population=_max_population
	population=0

func has_max_population()->bool:
	return population==max_population

func increase_population(value: int)->void:
	if not has_max_population():
		var new_population=int(clamp(population+value, 0, max_population))
		City.increase_population(new_population-population)
		population=new_population

func decrease_population(value: int)->void:
	var new_population=int(clamp(population-value, 0, max_population))
	City.decrease_population(population-new_population)
	population=new_population


func increase_max_population(value: int)->void:
	max_population+=value

func decrease_max_population(value:int)->void:
	max_population-=value
	var overpopulation=max(population-max_population,0)
	decrease_population(overpopulation)

func remove_all_population()->void:
	decrease_population(population)
