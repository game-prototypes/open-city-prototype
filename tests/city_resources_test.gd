extends "res://addons/gut/test.gd"

func before_each():
	watch_signals(City) 


func test_add_money():
	var original_money=City.money
	var new_money=original_money+10
	
	City.add_money(10)
	assert_eq(City.money, new_money)
	assert_signal_emitted_with_parameters(City, "money_updated", [new_money])

func test_remove_money():
	var original_money=City.money
	var new_money=original_money-10
	
	City.remove_money(10)
	assert_eq(City.money, new_money)
	assert_signal_emitted_with_parameters(City, "money_updated", [new_money])
