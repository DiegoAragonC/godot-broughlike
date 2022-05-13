extends Node

signal coin_grabbed

func has_coin(pos):
	for c in get_children():
		if c.map_pos == pos:
			return true
	return false
	
func clear_coins():
	for c in get_children():
		c.queue_free()


func grab_coin(pos):
	for c in get_children():
		if c.map_pos == pos:
			c.queue_free()
			emit_signal("coin_grabbed")
