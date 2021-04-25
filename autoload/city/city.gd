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
	_distribute_remaining_workers()
	emit_signal("population_updated", population)
	return population

func decrease_population(diff: int) -> int:
	population=population-diff
	_remove_extra_workers()
	emit_signal("population_updated", population)
	return population

func register_workplace(workplace: Workplace):
	workplace_list.append(workplace)
	_assign_possible_workers(workplace)

func remove_workplace(workplace: Workplace):
	var element_positon=workplace_list.find(workplace)
	workplace_list.remove(element_positon)
	_decrease_workforce(workplace.get_workers())
	_distribute_remaining_workers()

func get_available_workers()->int:
	return population-workforce

func _distribute_remaining_workers()->void:
	for workplace in workplace_list:
		_assign_possible_workers(workplace)

func _remove_extra_workers()->void:
	var extra_workers=workforce-population
	for workplace in workplace_list:
		if extra_workers>0:
			var workers=workplace.get_workers()
			var workers_to_remove=min(extra_workers, workers)
			_remove_workers(workers_to_remove, workplace)
			extra_workers=extra_workers-workers_to_remove
	assert(workforce<=population, "More workers than population")


func _assign_possible_workers(workplace:Workplace)->int:
	var available_workers=get_available_workers()
	if available_workers<=0:
		return 0
	var workers_to_find=workplace.get_remaining_workers()
	var workers_to_assign=min(workers_to_find,available_workers)
	_assign_workers(workers_to_assign, workplace)
	return workers_to_assign


func _assign_workers(workers:int, workplace:Workplace)->void:
	var current_workers=workplace.get_workers()
	_increase_workforce(workers)
	workplace.set_workers(current_workers+workers)

func _remove_workers(workers:int, workplace:Workplace)->void:
	var current_workers=workplace.get_workers()
	_decrease_workforce(workers)
	workplace.set_workers(current_workers-workers)

func _increase_workforce(value:int)->void:
	workforce+=value
	assert(workforce<=population, "More workers than population")

func _decrease_workforce(value:int)->void:
	workforce-=value
	assert(workforce>=0, "Less than 0 workforce")
