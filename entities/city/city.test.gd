extends TestSuite

var city:City

func before_each():
	var City=load("res://entities/city/city.tscn")
	city=City.instance()
	add_child_autofree(city)
	watch_signals(city) 


func test_add_money():
	var original_money=city.get_money()
	var new_money=original_money+10
	
	city.add_money(10)
	assert_eq(city.get_money(), new_money)
	assert_signal_emitted_with_parameters(city, "money_updated", [new_money])

func test_remove_money():
	var original_money=city.get_money()
	var new_money=original_money-10
	
	city.remove_money(10)
	assert_eq(city.get_money(), new_money)
	assert_signal_emitted_with_parameters(city, "money_updated", [new_money])
