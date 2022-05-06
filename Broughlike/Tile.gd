extends Node

const SIZE = 32

enum type {FLOOR, WALL}


func count_tiles(tile_type, tile_array = Globals.level):
	var count = 0
	for row in tile_array:
		for tile in row:
			if tile == tile_type:
				count += 1
	return count
	
	
func get_connected(type, array = Globals.level):
	var first_tile_pos = get_random(type, array)
	var connected = [first_tile_pos]
	var search_stack = [first_tile_pos]
	
	while search_stack.size() != 0:
		var current = search_stack.pop_back()
		var neighbors = get_neighbors(current.x, current.y)
		for tile_pos in neighbors:
			if not connected.has(tile_pos) and array[tile_pos.x][tile_pos.y] == type:
				connected.append(tile_pos)
				search_stack.append(tile_pos)

	return connected
	
	
func get_random(type, array = Globals.level):
	var tile_pos
	var found = false
	
	while not found:
		var rand_x = randi() % Globals.LEVEL_SIZE
		var rand_y = randi() % Globals.LEVEL_SIZE
		tile_pos = Vector2(rand_x, rand_y)
		
		if get_at(tile_pos, array) == type:
			found = true

	return tile_pos
	
	
func get_neighbors(tile_x, tile_y):
	var left = Vector2(tile_x-1, tile_y)
	var right = Vector2(tile_x+1, tile_y)
	var up = Vector2(tile_x, tile_y-1)
	var down = Vector2(tile_x, tile_y+1)
	var dirs = [left, right, up, down]
	var neighbors = []
	
	for dir in dirs:
		if is_in_level(dir):
			neighbors.append(dir)
	
	return neighbors
	
	
func get_passable_neighbors(tile_x, tile_y, tile_array = Globals.level):
	var neighbors = get_neighbors(tile_x, tile_y)
	var filtered = []
	for n in neighbors:
		var pos = n
		if is_passable(pos, tile_array):
			filtered.append(pos)
	return filtered


func get_at(tile_pos, tile_array = Globals.level):
	if not is_in_level(tile_pos):
		return null
	return tile_array[tile_pos.x][tile_pos.y]


func is_passable(tile_pos, tile_array = Globals.level):
	return get_at(tile_pos, tile_array) == Tile.type.FLOOR


func is_in_level(tile_pos):
	return tile_pos.x >= 0 and tile_pos.x < Globals.LEVEL_SIZE and\
	 	tile_pos.y >= 0 and tile_pos.y < Globals.LEVEL_SIZE


func is_border(x, y):
	return x == 0 or x == Globals.LEVEL_SIZE-1 or y == 0 or y == Globals.LEVEL_SIZE-1



