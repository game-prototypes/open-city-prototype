extends Reference

class_name Utils

static func get_tiles_around(tile:Vector2, corners:bool=true)->Array:
	var result=[]
	for i in range(tile.x-1,tile.x+2):
		for j in range(tile.y-1, tile.y+2):
			var pos=Vector2(i,j)
			if corners:
				if pos!=tile:
					result.append(pos)
			else:
				if pos!=tile and (pos.x==tile.x or pos.y==tile.y):
					result.append(pos)
	return result


static func merge_dict(d1: Dictionary, d2:Dictionary)->Dictionary:
	var keys=d2.keys()
	for key in keys:
		d1[key]=d2[key]
	return d1


static func arr2vector(arr: Array)->Vector2:
	return Vector2(arr[0], arr[1])

static func vector2arr(v: Vector2)->Array:
	return [v.x, v.y]
