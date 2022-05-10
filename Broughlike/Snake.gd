extends "res://scripts/Monster.gd"


func take_turn(player_pos):
	attacked_this_turn = false
	.take_turn(player_pos)
	
	if not attacked_this_turn:
		 .take_turn(player_pos)
