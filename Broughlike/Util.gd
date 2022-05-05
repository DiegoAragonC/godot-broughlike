extends Node

func map_to_pixel(map_pos):
	return map_pos * Globals.TILE_SIZE

func pixel_to_map(pixel_pos):
	return int(pixel_pos / Globals.TILE_SIZE)


