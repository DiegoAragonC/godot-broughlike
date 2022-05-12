extends Node2D

var life_counter = Globals.monster_appear_turns + 1

onready var Spr = $Sprite


func update():
	if life_counter > 0:
		animate()
		life_counter -= 1
	else:
		queue_free()
		
func animate():
	Spr.frame = (Spr.frame + 1) % Spr.hframes
	
