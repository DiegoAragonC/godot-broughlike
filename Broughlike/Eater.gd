extends "res://scripts/Monster.gd"

func take_turn(player_pos):
	var neighbors = Tile.get_neighbors_of_type(Tile.type.WALL, map_pos.x, map_pos.y) 
	if neighbors.size() > 0:
		var target = Util.closest_to(neighbors, player_pos)
		var move_dir = -1 if target.x < map_pos.x else 1
		emit_signal("modified_map", target, Tile.type.FLOOR)
		heal(0.5)
		animate(move_dir)
	else:
		.take_turn(player_pos)
