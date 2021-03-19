extends "res://addons/gut/test.gd"

func before_each():
	pass

func after_each():
	pass

func before_all():
	pass

func after_all():
	pass

func test_storage_is_empty():
	var storage=Storage.new(10)
	var is_empty=storage.is_empty()
	assert_true(is_empty)


class TestStore:
	extends "res://addons/gut/test.gd"

	func test_store_resource():
		var storage=Storage.new(10)
		assert_true(storage.store(1, 8))
		assert_eq(storage.get_resource_quantity(1), 8)
		assert_false(storage.is_empty())
	
	func test_store_over_limit():
		var storage=Storage.new(10)
		assert_false(storage.store(1, 20))
		assert_eq(storage.get_resource_quantity(1), 0)
		assert_true(storage.is_empty())
