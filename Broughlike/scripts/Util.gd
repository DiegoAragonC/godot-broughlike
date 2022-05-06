extends Node

func map_to_pixel(map_pos):
	return map_pos * Tile.SIZE

func pixel_to_map(pixel_pos):
	return int(pixel_pos / Tile.SIZE)

func closest_to(pos_array, pos):
	var closest = {"pos": pos_array[0], "dist": distance(pos_array[0], pos)}
	
	for i in range(1, pos_array.size()):
		var dist = distance(pos_array[i], pos)
		if dist < closest.dist:
			closest.pos = pos_array[i]
			closest.dist = dist

	return closest.pos


func distance(a, b):
	var dx = a.x - b.x
	var dy = a.y - b.y
	return sqrt((dx * dx) + (dy * dy))
