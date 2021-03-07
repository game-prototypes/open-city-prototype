extends Node2D

class_name Map

onready var terrain:TileMap = $Terrain
onready var roads:Roads = $Roads
onready var buildings:Buildings = $Buildings
onready var elements = $Elements


signal tile_selected(tile, building)

var tile_to_items: Dictionary = Dictionary()
#var items_to_tile: Dictionary = Dictionary()

func _ready():
	assert(terrain.cell_size[0]==roads.cell_size[0], "Error, terrain tile size != roads tile size")
	assert(buildings.cell_size[0]==roads.cell_size[0], "Error, buildings tile size != roads tile size")


func can_build(tile) -> bool:
	var road_id=roads.get_cell(tile.x, tile.y)
	var building_id=buildings.get_cell(tile.x, tile.y)
	return road_id==-1 and building_id==-1

func can_build_area(tile:Vector2, area: Vector2) -> bool:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			if not can_build(Vector2(i, j)):
				return false
	return true

func build(tile: Vector2, building: Building, area: Vector2) -> void:
	buildings.build(tile,building,area)
	elements.add_child(building)
	_add_item(tile, area, building)

func add_person(person: Node2D) -> void:
	elements.add_child(person)

func _add_item(tile: Vector2, area: Vector2, item: Node2D) -> void:
	for i in range(tile.x,tile.x+area.x):
		for j in range(tile.y, tile.y+area.y):
			tile_to_items[Vector2(i,j)]=item

func build_road(tile: Vector2, road_id: int)-> void:
	roads.build_road(tile, road_id)

func pos2tile(tile: Vector2)->Vector2:
	return terrain.world_to_map(tile)

# Returns top corner
func tile2pos(tile: Vector2)->Vector2:
	return terrain.map_to_world(tile)

func tile_center_pos(tile: Vector2) -> Vector2:
	var half_size=roads.cell_size.y/2
	var top_tile_pos=roads.map_to_world(tile)
	return Vector2(top_tile_pos.x, top_tile_pos.y+half_size)

func find_path(from: Vector2, to: Vector2)->PoolVector2Array:
	return roads.find_path(from, to)


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

func get_road_tiles_next_to(tile: Vector2) -> Array:
	var tiles=[]
	for i in range(tile.x-1,tile.x+2):
		for j in range(tile.y-1, tile.y+2):
			var current_tile=Vector2(i,j)
			if current_tile!=tile and not _is_diagonal(tile, current_tile):
				if roads.get_cell(current_tile.x, current_tile.y)!=-1:
					tiles.append(current_tile)
	return tiles

func _is_diagonal(tile1:Vector2, tile2:Vector2)-> bool:
	return tile1.x!=tile2.x and tile1.y!=tile2.y


func get_shortest_path(tile1: Vector2, tile2: Vector2) -> PoolVector2Array:
	var tilesA=get_road_tiles_next_to(tile1)
	var tilesB=get_road_tiles_next_to(tile2)
	var selected_path=PoolVector2Array()
	
	for i in tilesA:
		for j in tilesB:
			var candidate_path=find_path(i, j)
			if candidate_path.size() > 0:
				if selected_path.size() == 0 or candidate_path.size() < selected_path.size():
					selected_path=candidate_path

	return selected_path

func get_buildings_of_type(type: String)->Array:
	return get_tree().get_nodes_in_group(type)
