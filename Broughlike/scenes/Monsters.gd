extends Node

func get_monster_at(tile_pos):
	for m in get_children():
		if m.map_pos == tile_pos:
			return m
	return null

func get_player():
	for m in get_children():
		if m.is_in_group("player"):
			return m
	return null
	
	
func tick():
	var player_pos = get_player().map_pos
	
	for m in get_children():
		if not m.is_in_group("player"):
			m.take_turn(player_pos)

