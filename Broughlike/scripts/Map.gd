extends Node2D


var level = []


func _ready():
	randomize()
	level = generate_level(Globals.LEVEL_SIZE)
	draw_level(level)
	Globals.level = level
	


func generate_level(size):
	var	tiles = null
	var floor_tile = Tile.type.FLOOR
	# keep trying until we get a connected level
	while not tiles\
	 or Tile.count_tiles(floor_tile, tiles) != Tile.get_connected(floor_tile, tiles).size():	
		tiles = []
		for x in range(size):
			tiles.append([])
			for y in range(size):
				if Tile.is_border(x, y) or randf() < 0.3:
					tiles[x].append(Tile.type.WALL)
				else:
					tiles[x].append(Tile.type.FLOOR)
		
	return tiles
	
	
func draw_level(level):
	var tile_map = $Tiles
	for x in range(Globals.LEVEL_SIZE):
		for y in range(Globals.LEVEL_SIZE):
			tile_map.set_cell(x, y, level[x][y])








