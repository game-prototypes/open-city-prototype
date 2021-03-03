extends Resource

class_name BuildingResource

enum Type {BUILDING, ROAD}

export var name: String = ""
export var area: Vector2 = Vector2.ONE
export var scene: PackedScene = null
const type=Type.BUILDING

func instantiate_building() -> Building:
	var build_instance=scene.instance()
	return build_instance
