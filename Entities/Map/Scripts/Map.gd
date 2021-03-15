extends Node2D

class_name Map

var navigation: MapNavigation
var resource_manager: ResourceManager

onready var _terrain:TileMap = $Terrain
onready var _roads:Roads = $Roads
onready var _buildings:Buildings = $Buildings
onready var _elements = $Elements

signal tile_selected(tile, building)

func _ready():
	assert(_terrain.cell_size[0]==_roads.cell_size[0], "Error, terrain tile size != roads tile size")
	navigation = MapNavigation.new(self, _roads)
	resource_manager = ResourceManager.new(navigation)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var tile=pos2tile(get_global_mouse_position())
			_buildings.handle_building_click(tile)
			emit_signal("tile_selected", tile)


func can_build(tile) -> bool:
	var has_road=_roads.has_road(tile)
	var has_building=_buildings.has_building(tile)
	return not has_road and not has_building

func can_build_area(tile:Vector2, area: Vector2) -> bool:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			if not can_build(Vector2(i, j)):
				return false
	return true

func build(tile: Vector2, building: Building) -> void:
	Log.info("Build", tile, building)
	_buildings.build(tile,building)
	_elements.add_child(building)

func demolish_tile(tile: Vector2) -> bool:
	Log.info("Demolish", tile)
	if _roads.has_road(tile):
		# TODO: recalculate paths signal		
		_roads.remove_road(tile)
		return true
	elif _buildings.has_building(tile):
		_buildings.remove_building_from_tile(tile)
		return true
	return false

func add_person(person: Node2D) -> void:
	_elements.add_child(person)

func build_road(tile: Vector2, road_id: int)-> void:
	_roads.build_road(tile, road_id)

func pos2tile(tile: Vector2)->Vector2:
	return _terrain.world_to_map(tile)

# Returns top corner
func tile2pos(tile: Vector2)->Vector2:
	return _terrain.map_to_world(tile)

func tile_center_pos(tile: Vector2) -> Vector2:
	var half_size=_roads.cell_size.y/2
	var top_tile_pos=_roads.map_to_world(tile)
	return Vector2(top_tile_pos.x, top_tile_pos.y+half_size)

func get_buildings_of_type(type: String)->Array:
	return get_tree().get_nodes_in_group(type)
