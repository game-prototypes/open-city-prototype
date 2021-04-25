extends Node

var money:int = 1000
var population:int=0
var workforce:int=0

var map

signal money_updated(money)
signal population_updated(population)

var workplace_list:=[]

func set_map(_map)->void:
	map=_map

func add_money(diff: int) -> int:
	money=money+diff
	emit_signal("money_updated", money)
	return money

func remove_money(diff: int) -> int:
	return add_money(-diff)

func increase_population(diff: int) -> int:
	population=population+diff
	# TODO: update workforce
	emit_signal("population_updated", population)
	return population

func decrease_population(diff: int) -> int:
	# TODO: update workforce
	return increase_population(-diff)

func register_workplace(workplace: Workplace):
	workplace_list.append(workplace)
	var workers_to_find=workplace.get_remaining_workers()
	var available_workers=get_available_workers()
	var workers_to_assign=min(workers_to_find,available_workers)
	_assign_workers(workers_to_assign, workplace)

func remove_workplace(workplace: Workplace):
	var element_positon=workplace_list.find(workplace)
	workplace_list.remove(element_positon)
	_decrement_workforce(workplace.get_workers())

func get_available_workers()->int:
	return population-workforce

func _assign_workers(workers:int, workplace:Workplace)->void:
	var current_workers=workplace.get_workers()
	increase_workforce(workers)
	workplace.set_workers(current_workers+workers)

func increase_workforce(value:int)->void:
	workforce+=value
	assert(workforce<=population, "More workers than population")

func _decrement_workforce(value:int)->void:
	workforce-=value
	assert(workforce>=0, "Less than 0 workforce")
