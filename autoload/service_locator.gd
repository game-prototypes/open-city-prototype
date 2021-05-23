extends Node

var city

func get_city()->City:
	assert(city!=null, "City not available")
	return city

func set_city(c):
	city=c
