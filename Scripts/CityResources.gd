extends Node

class_name CityResources

var money:int = 1000

signal money_updated(money)


func add_money(diff: int) -> int:
	money=money+diff
	emit_signal("money_updated", money)
	return money
