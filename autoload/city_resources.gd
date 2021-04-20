extends Node

var money:int = 1000
var population:int=0

signal money_updated(money)
signal population_updated(population)

func add_money(diff: int) -> int:
	money=money+diff
	emit_signal("money_updated", money)
	return money

func remove_money(diff: int) -> int:
	return add_money(-diff)

func increase_population(diff: int) -> int:
	population=population+diff
	emit_signal("population_updated", population)
	return population

func decrease_population(diff: int) -> int:
	return increase_population(-diff)
