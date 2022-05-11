extends "res://scripts/Monster.gd"


func take_turn(player_pos):
	if stunned:
		stunned = false
		return
	
	var neighbors = Tile.get_passable_neighbors(map_pos.x, map_pos.y) 
	var rand_index = randi() % neighbors.size()
	var target = neighbors[rand_index]
	var move_dir = -1 if target.x < map_pos.x else 1
	try_move(target)
	animate(move_dir)
