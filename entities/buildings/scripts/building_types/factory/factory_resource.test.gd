extends TestSuite

class TestFactoryInput:
	extends TestSuite
	const FactoryInputResource=preload("./factory_input_resource.gd")
	
	var resource:FactoryInputResource
	var required_quantity=10
	
	func before_each():
		resource=FactoryInputResource.new(1,required_quantity)

	func test_add_resource_quantity():
		assert_eq(resource.current_quantity, 0)
		resource.add_resource_quantity(1)
		assert_eq(resource.current_quantity, 1)
		resource.add_resource_quantity(1)
		assert_eq(resource.current_quantity, 2)
	
	func test_has_enough_quantity():
		assert_false(resource.has_enough_quantity())
		resource.add_resource_quantity(required_quantity)
		assert_true(resource.has_enough_quantity())
	
	func test_get_required_quantity():
		assert_eq(resource.get_required_quantity(), required_quantity)
		resource.add_resource_quantity(1)
		assert_eq(resource.get_required_quantity(), required_quantity-1)
