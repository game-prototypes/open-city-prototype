extends Node

class_name City

export var taxes_rate:float=0.2
var money:float = 1000.0
var population:int=0
var workforce:int=0

onready var building_update_timer:=$CityUpdateTimer
onready var city_workplaces:=$CityWorkplaces

var map

signal money_updated(money)
signal population_updated(population)

func _ready():
	building_update_timer.connect("timeout", self, "_on_city_update", [building_update_timer.wait_time])
	self.connect("population_updated", city_workplaces, "update_workforce")
	ServiceLocator.set_city(self)

func set_map(_map)->void:
	map=_map

func add_money(diff: int) -> int:
	money=money+diff
	emit_signal("money_updated", get_money())
	return get_money()

func remove_money(diff: int) -> int:
	return add_money(-diff)

func get_money()->int:
	return int(money)

func increase_population(diff: int) -> int:
	population=population+diff
	emit_signal("population_updated", population)
	return population

func decrease_population(diff: int) -> int:
	population=population-diff
	emit_signal("population_updated", population)
	return population

func register_workplace(workplace: Workplace):
	city_workplaces.register_workplace(workplace)

func remove_workplace(workplace: Workplace):
	city_workplaces.remove_workplace(workplace)

func begin_game(data:Dictionary):# TODO
	print(data)

func _on_city_update(delta: float) -> void:
	var taxes=delta*taxes_rate*population
	add_money(taxes)
