extends TestSuite

var Main=load("res://scenes/main.tscn")
var main
var road_id=1

func before_each():
	main=Main.instance()
	add_child_autofree(main)
	simulate(main, 1, 1)

func test_player_building():
	assert_eq(main.map._elements.get_children().size(), 0)
	
	main.hud.emit_signal("building_resource_selected", main.buildings[0])
	main.map.emit_signal("tile_selected", Vector2(10,10), null)
	simulate(main, 1, 100)
	
	var elements=main.map._elements.get_children()
	assert_eq(elements.size(), 1)
	assert_eq(elements[0].map_position, Vector2(10,10))
	

func test_transporter():
	pending()
	return
	var farm_name="Farm"
	var storage_name="Storage Yard"
	var house_name="House"
	
	var farm_resource=main.get_building_resource(farm_name)
	var storage_yard_resource=main.get_building_resource(storage_name)
	var house_resource=main.get_building_resource(house_name)
	var farm = farm_resource.instantiate_building(Vector2(10,10))
	watch_signals(farm) 
	var storage_yard = storage_yard_resource.instantiate_building(Vector2(10,12))
	var house = house_resource.instantiate_building(Vector2(9,11))
	
	autofree(farm)
	autofree(storage_yard)
	autofree(house)
	main.map.build(farm)
	main.map.build(storage_yard)
	main.map.build(house)
	
	main.map.build_road(Vector2(10,11), road_id)
	#simulate(main, 5, 100)
	
	#assert_signal_emitted(farm, "factory_production_finished")
