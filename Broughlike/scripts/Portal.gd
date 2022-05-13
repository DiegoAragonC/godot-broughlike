extends Node2D

var map_pos
onready var Spr = $Sprite



func animate():
	Spr.frame = (Spr.frame + 1) % Spr.hframes
