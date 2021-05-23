extends Reference

class_name Serializer

static func serialize_tilemap(tilemap:TileMap, size:Vector2) -> Array:
	var saved_matrix=[]
	for i in range(size[0]):
		saved_matrix.append([])
		for j in range(size[1]):
			saved_matrix[i].append(tilemap.get_cell(i,j))
	
	return saved_matrix


static func load_tilemap(raw: String, tilemap:TileMap):
	var parsed=JSON.parse(raw)
	# TODO: check tiles.error
	var tiles=parsed.result
	var rows=tiles.size()
	for i in range(rows):
		var columns=tiles[i].size()
		for j in range(columns):
			tilemap.set_cell(i,j,tiles[i][j])
	


static func serialize_array(arr:Array)->Array:
	var result=[]
	for item in arr:
		result.append(item.serialize())
	return result
