extends Node2D

enum {LOADING, TITLE, RUNNING, DEAD}

var player_scene = preload("res://scenes/Player.tscn")
var bird_scene = preload("res://scenes/Bird.tscn")
var snake_scene = preload("res://scenes/Snake.tscn")
var tank_scene = preload("res://scenes/Tank.tscn")
var eater_scene = preload("res://scenes/Eater.tscn")
var jester_scene = preload("res://scenes/Jester.tscn")
var tomb_scene = preload("res://scenes/Tomb.tscn")
var vortex_scene = preload("res://scenes/Vortex.tscn")

var monster_scenes = [bird_scene, snake_scene, tank_scene, eater_scene, jester_scene]
var level = 1
var state = LOADING
var start_hp = 3
var num_levels = 6

var Player
var Tomb

var spawn_rate = 15
var spawn_counter = spawn_rate 

onready var Map = $Map
onready var Monsters = $Monsters
onready var Vortices = $Vortices



func _ready():
	go_to_start_screen()
	

func _input(event):
	if event is InputEventKey and event.pressed:
		match state:
			TITLE:
				start_game()
			DEAD:
				go_to_start_screen()
			RUNNING:
				pass


func go_to_start_screen():
	state = TITLE
	$GUI.show_title()


func start_game():
	$GUI.hide_title()
	
	level = 1
	spawn_rate = 15
	spawn_counter = spawn_rate
	
	generate_map()
	create_player(start_hp)
	create_monsters()
	
	state = RUNNING


func generate_map():
	clear_level()
	$Map.generate()


func create_player(hp):
	Player = player_scene.instance()
	var p_start_pos = Tile.get_random(Tile.type.FLOOR, Map.level)
	Player.initialize(p_start_pos, self)
	Player.hp = hp
	Monsters.add_child(Player)


func create_monsters():
	var num_monsters = level + 1
	for i in range(num_monsters):
		spawn_monster()


func spawn_monster():
	var i = randi() % monster_scenes.size()
	var m = monster_scenes[i].instance()
	var pos = Tile.get_random(Tile.type.FLOOR, Map.level)
	while Monsters.get_monster_at(pos):
		pos = Tile.get_random(Tile.type.FLOOR, Map.level) 
	
	m.initialize(pos, self)
	Monsters.add_child(m)
	
	var v = vortex_scene.instance()
	v.position = m.position
	Vortices.add_child(v)


func clear_level():
	if Tomb:
		Tomb.queue_free()
	if Monsters.get_child_count() > 0:
		Monsters.clear_all()
	if Vortices.get_child_count() > 0:
		Vortices.clear_all()


func update_spawn_counter():
	spawn_counter -= 1
	if spawn_counter <= 0:
		spawn_monster()
		spawn_counter = spawn_rate
		spawn_rate -= 1
		

func _on_Monster_tried_move(monster, target_pos):
	if Tile.is_passable(target_pos, Map.level):
		var monster_at_tile = Monsters.get_monster_at(target_pos)
		if not monster_at_tile:
			monster.move(target_pos)
		else:
			if monster.is_in_group("player") != monster_at_tile.is_in_group("player"):
				if monster_at_tile.appeared:
					monster.attacked_this_turn = true
					monster_at_tile.stunned = true
					monster_at_tile.hit(1)
	if monster.is_in_group("player"):
		update_spawn_counter()
		Monsters.tick()
		Vortices.tick()


func _on_Monster_modified_map(tile_pos, tile_type):
	Map.change_tile(tile_pos, tile_type)


func _on_Monster_died(monster, pos):
	if monster.is_in_group("player"):
		Tomb = tomb_scene.instance()
		Tomb.position = pos
		add_child(Tomb)
		yield(get_tree().create_timer(0.5), "timeout")
		state = DEAD
