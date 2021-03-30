extends "res://addons/gut/test.gd"

func test_building():
	var Map=load("res://entities/map/map.tscn")
	var map=Map.instance()
	add_child_autofree(map)
	var can_build=map.can_build(Vector2(10,10))
	assert_true(can_build)
