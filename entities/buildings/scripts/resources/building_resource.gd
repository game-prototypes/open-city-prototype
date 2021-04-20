extends Resource

class_name BuildingResource

enum Type {BUILDING, ROAD}

export var name: String = ""
export var area: Vector2 = Vector2.ONE
export var scene: PackedScene = null
export var price: int = 0
const type=Type.BUILDING

func instantiate_building(tile:Vector2, map: Map) -> Building:
	var build_instance=scene.instance() as Building
	assert(build_instance is Building, "Building incorrect type")
	build_instance.map_position=tile
	build_instance.map=map
	build_instance.stats=self
	return build_instance
