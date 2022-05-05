extends Node2D

const LEVEL_SIZE = 9

var level = []


func _ready():
	randomize()
	level = generate_level(LEVEL_SIZE)
	draw_level(level)


func generate_level(size):
	var	tiles = []
	for x in range(size):
		tiles.append([])
		for y in range(size):
			if randf() < 0.3:
				tiles[x].append(Globals.tile_types.WALL)
			else:
				tiles[x].append(Globals.tile_types.FLOOR)
	
	return tiles

	
func draw_level(level):
	var tile_map = $Tiles
	for x in range(LEVEL_SIZE):
		for y in range(LEVEL_SIZE):
			tile_map.set_cell(x, y, level[x][y])


func get_random_tile(type):
	var tile_pos
	var found = false
	
	while not found:
		var rand_x = randi() % LEVEL_SIZE
		var rand_y = randi() % LEVEL_SIZE
		tile_pos = Vector2(rand_x, rand_y)
		
		if get_tile_at(tile_pos) == type:
			found = true

	return tile_pos


func get_tile_at(tile_pos):
	if not is_in_level(tile_pos):
		return -1
	return level[tile_pos.x][tile_pos.y]


func is_tile_passable(tile_pos):
	return get_tile_at(tile_pos) == Globals.tile_types.FLOOR


func is_in_level(tile_pos):
	return tile_pos.x > 0 and tile_pos.x < LEVEL_SIZE and\
	 	tile_pos.y > 0 and tile_pos.y < LEVEL_SIZE
