extends Node2D

const LEVEL_SIZE = 11

var level = []


func _ready():
	randomize()
	level = generate_level(LEVEL_SIZE)
	draw_level(level)


func generate_level(size):
	var	tiles = null
	var floor_tile = Globals.tile_types.FLOOR
	
	while not tiles\
	 or get_tile_count(floor_tile, tiles) != get_connected(floor_tile, tiles).size():	
		tiles = []
		for x in range(size):
			tiles.append([])
			for y in range(size):
				if is_border_tile(x, y) or randf() < 0.3:
					tiles[x].append(Globals.tile_types.WALL)
				else:
					tiles[x].append(Globals.tile_types.FLOOR)
		
	return tiles

func get_tile_count(type, array):
	var count = 0
	for row in array:
		for tile in row:
			if tile == type:
				count += 1
	return count
	
	
func get_connected(type, array):
	var first_tile_pos = get_random_tile(type, array)
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
	
	
func draw_level(level):
	var tile_map = $Tiles
	for x in range(LEVEL_SIZE):
		for y in range(LEVEL_SIZE):
			tile_map.set_cell(x, y, level[x][y])


func get_random_tile(type, array):
	var tile_pos
	var found = false
	
	while not found:
		var rand_x = randi() % LEVEL_SIZE
		var rand_y = randi() % LEVEL_SIZE
		tile_pos = Vector2(rand_x, rand_y)
		
		if get_tile_at(tile_pos, array) == type:
			found = true

	return tile_pos


func get_tile_at(tile_pos, tile_array):
	if not is_in_level(tile_pos):
		return -1
	return tile_array[tile_pos.x][tile_pos.y]


func is_tile_passable(tile_pos, tile_array):
	return get_tile_at(tile_pos, tile_array) == Globals.tile_types.FLOOR


func is_in_level(tile_pos):
	return tile_pos.x >= 0 and tile_pos.x < LEVEL_SIZE and\
	 	tile_pos.y >= 0 and tile_pos.y < LEVEL_SIZE

func is_border_tile(x, y):
	return x == 0 or x == LEVEL_SIZE-1 or y == 0 or y == LEVEL_SIZE-1
