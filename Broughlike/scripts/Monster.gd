extends Node2D

signal tried_move(target_pos)
signal modified_map(tile_pos, tile_type)
signal died(monster, pos)

const step_size = Tile.SIZE

export (float) var hp
export (float) var max_hp = 4

var heart_scene = preload("res://scenes/Heart.tscn")
var map_pos
var attacked_this_turn = false
var stunned = false
var teleport_counter = Globals.monster_appear_turns
var appeared = false

onready var Monsters = get_node("..")


func _ready():
	add_to_group("monsters")
	$Sprite.hide()
	

func initialize(start_pos, connection):
	connect("tried_move", connection, "_on_Monster_tried_move")
	connect("modified_map", connection, "_on_Monster_modified_map")
	connect("died", connection, "_on_Monster_died")
	
	map_pos = start_pos
	move(start_pos)


func move(tile_pos):
	map_pos = tile_pos
	global_position = Util.map_to_pixel(map_pos)
	

func try_move(tile_pos):
	emit_signal("tried_move", self, tile_pos)
	

func appear():
	$Sprite.show()
	draw_hp()
	appeared = true


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


func draw_hp():
	clear_hp()
	var heart_size = 8
	var pad = 2
	for i in range(floor(hp)):
		var h = heart_scene.instance()
		h.position.x = (heart_size + pad) * i
		h.position.y = Tile.SIZE - heart_size
		$Hp.add_child(h)


func clear_hp():
	for h in $Hp.get_children():
		h.queue_free()


func hit(dmg):
	hp -= dmg
	draw_hp()
	if hp <= 0:
		die()
	
		
func die():
	emit_signal("died", self, global_position)
	queue_free()
	
func heal(amount):
	hp = min(max_hp, hp + amount)
	draw_hp()
	
