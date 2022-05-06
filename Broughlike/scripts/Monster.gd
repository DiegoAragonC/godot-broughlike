extends Node2D

signal tried_move(target_pos)

const step_size = Tile.SIZE

export (int) var hp

var map_pos

onready var Monsters = get_node("..")


func _ready():
	add_to_group("monsters")

func initialize(start_pos, connection):
	connect("tried_move", connection, "_on_Monster_tried_move")
	
	map_pos = start_pos
	move(start_pos)


func move(tile_pos):
	map_pos = tile_pos
	global_position = Util.map_to_pixel(map_pos)
	

func try_move(tile_pos):
	emit_signal("tried_move", self, tile_pos)


func take_turn(player_pos):
	var neighbors = Tile.get_passable_neighbors(map_pos.x, map_pos.y) 
	var closest = Util.closest_to(neighbors, player_pos)
	var move_dir = -1 if closest.x < map_pos.x else 1
	try_move(closest)
	animate(move_dir)


func animate(dir):
	var current_frame = $Sprite.frame
	var number_of_frames = $Sprite.hframes
	$Sprite.frame = (current_frame + 1) % number_of_frames
	
	if dir == -1:
		$Sprite.flip_h = true
	elif dir == 1:
		$Sprite.flip_h = false

