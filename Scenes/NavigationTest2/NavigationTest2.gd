extends Node2D

onready var map: Map = $IsometricMap
onready var line:Line2D=$Line2D
onready var buildings:TileMap=$IsometricMap/Buildings

# Called when the node enters the scene tree for the first time.
func _ready():
	var tiles=buildings.get_used_cells_by_id(1)
	var path=map.get_shortest_path(tiles[0], tiles[1])
	print(path)
	var line_path=PoolVector2Array()
	for p in path:
		line_path.append(tile_center_pos(p))
	line.points=line_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func tile_center_pos(tile):
	var half_size=buildings.cell_size.y/2
	var top_tile_pos=buildings.map_to_world(tile)
	return Vector2(top_tile_pos.x, top_tile_pos.y+half_size)
