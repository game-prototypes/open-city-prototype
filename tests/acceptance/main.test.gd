extends TestSuite

func test_player_building():
	var Main=load("res://scenes/main.tscn")
	var main=Main.instance()
	add_child_autofree(main)
	simulate(main, 1, 10)
	assert_eq(main.map._elements.get_children().size(), 0)
	
	main.hud.emit_signal("building_resource_selected", main.buildings[0])
	main.map.emit_signal("tile_selected", Vector2(10,10), null)
	simulate(main, 1, 100)
	
	var elements=main.map._elements.get_children()
	assert_eq(elements.size(), 1)
	assert_eq(elements[0].map_position, Vector2(10,10))
	
