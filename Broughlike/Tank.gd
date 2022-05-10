extends "res://scripts/Monster.gd"

func take_turn(player_pos):
	var started_stunned = stunned
	
	.take_turn(player_pos)
	
	if not started_stunned:
		stunned = true
