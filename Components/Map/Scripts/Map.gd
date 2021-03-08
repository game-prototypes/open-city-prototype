extends Node2D

class_name Map

var navigation: MapNavigation

onready var _terrain:TileMap = $Terrain
onready var _roads:Roads = $Roads
onready var _buildings:Buildings = $Buildings
onready var _elements = $Elements


signal tile_selected(tile, building)

var tile_to_items: Dictionary = Dictionary()

func _ready():
	assert(_terrain.cell_size[0]==_roads.cell_size[0], "Error, terrain tile size != roads tile size")
	assert(_buildings.cell_size[0]==_roads.cell_size[0], "Error, buildings tile size != roads tile size")
	navigation = MapNavigation.new(self, _roads)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var tile=pos2tile(get_global_mouse_position())
			if tile_to_items.has(tile):
				var element=tile_to_items[tile]
				if element is Building:
					element._on_building_select()
			else:
				print("Map click ", tile)
				emit_signal("tile_selected", tile)


func can_build(tile) -> bool:
	var road_id=_roads.get_cell(tile.x, tile.y)
	var building_id=_buildings.get_cell(tile.x, tile.y)
	return road_id==-1 and building_id==-1

func can_build_area(tile:Vector2, area: Vector2) -> bool:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			if not can_build(Vector2(i, j)):
				return false
	return true

func build(tile: Vector2, building: Building, area: Vector2) -> void:
	_buildings.build(tile,building,area)
	_elements.add_child(building)
	_add_item(tile, area, building)

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

func _add_item(tile: Vector2, area: Vector2, item: Node2D) -> void:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			tile_to_items[Vector2(i,j)]=item
