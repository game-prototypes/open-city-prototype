extends "res://addons/gut/test.gd"

func before_each():
	watch_signals(CityResources) 


func test_add_money():
	var original_money=CityResources.money
	var new_money=original_money+10
	
	CityResources.add_money(10)
	assert_eq(CityResources.money, new_money)
	assert_signal_emitted_with_parameters(CityResources, "money_updated", [new_money])

func test_remove_money():
	var original_money=CityResources.money
	var new_money=original_money-10
	
	CityResources.remove_money(10)
	assert_eq(CityResources.money, new_money)
	assert_signal_emitted_with_parameters(CityResources, "money_updated", [new_money])
