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
		if m.stunned or m.teleport_counter > 0:
			m.teleport_counter -= 1
			m.stunned = false
		elif not m.appeared:
			m.appear()
		elif not m.is_in_group("player"):
			m.take_turn(player_pos)


func clear_all():
	for m in get_children():
		m.queue_free()
