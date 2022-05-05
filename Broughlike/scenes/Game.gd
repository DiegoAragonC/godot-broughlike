extends Node2D

onready var Map = $Map
onready var Player = $Player


func _ready():
	Player.start_pos = Map.get_random_tile(Globals.tile_types.FLOOR, Map.level)
	Player.initialize()


func _on_Player_tried_move(map_pos):
	if Map.is_tile_passable(map_pos, Map.level):
		Player.move(map_pos)
