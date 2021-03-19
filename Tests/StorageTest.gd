extends "res://addons/gut/test.gd"



func before_each():
	pass

func after_each():
	pass

func before_all():
	pass

func after_all():
	pass

func test_empty_storage():
	var storage=Storage.new(10)
	
	assert_true(storage.is_empty())
	assert_eq(storage.stored_quantity, 0)
	assert_eq(storage.get_occupied_space(),0)


class TestStore:
	extends "res://addons/gut/test.gd"
	
	var test_resource_1=1
	var test_resource_2=2

	func test_store_resource():
		var storage=Storage.new(10)
		assert_true(storage.store(test_resource_1, 10))
		assert_eq(storage.get_resource_quantity(test_resource_1), 10)
		assert_false(storage.is_empty())
	
	func test_store_over_limit():
		var storage=Storage.new(10)
		assert_false(storage.store(test_resource_1, 20))
		assert_eq(storage.get_resource_quantity(test_resource_1), 0)
		assert_true(storage.is_empty())
	
	func test_store_multiple_times():
		var storage=Storage.new(10)
		assert_true(storage.store(test_resource_1, 2))
		assert_true(storage.store(test_resource_1, 2))
		assert_eq(storage.get_resource_quantity(test_resource_1), 4)
	
	func test_store_different_resources():
		var storage=Storage.new(10)
		assert_true(storage.store(test_resource_1, 2))
		assert_true(storage.store(test_resource_2, 2))
		assert_eq(storage.stored_quantity, 4)
		assert_eq(storage.get_occupied_space(),4)


class TestRemove:
	extends "res://addons/gut/test.gd"
	
	var test_resource_1=1

	func test_remove_resource():
		var storage=Storage.new(10)
		storage.stored_resources={
			test_resource_1: 6
		}
		storage.stored_quantity=6
		
		storage.remove(test_resource_1, 3)
		assert_eq(storage.get_resource_quantity(test_resource_1), 3)
		
		storage.remove(test_resource_1, 3)
		assert_eq(storage.get_resource_quantity(test_resource_1), 0)
		assert_true(storage.is_empty())
