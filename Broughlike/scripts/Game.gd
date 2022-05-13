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
var door_scene = preload("res://scenes/Portal.tscn")
var coin_scene = preload("res://scenes/Coin.tscn")

var monster_scenes = [bird_scene, snake_scene, tank_scene, eater_scene, jester_scene]
var level = 1
var state = LOADING
var start_hp = 3
var num_levels = 6
var num_treasure = 3
var score = 0
var high_score

var Player
var Tomb
var Door

var spawn_rate = 15
var spawn_counter = spawn_rate 

onready var Map = $Map
onready var Monsters = $Monsters
onready var Vortices = $Vortices
onready var Treasure = $Treasure



func _ready():
	high_score = load_high_score()
	go_to_start_screen()


func _input(event):
	if event is InputEventKey and event.pressed:
		match state:
			TITLE:
				start_game()
			DEAD:
				update_high_score()
				go_to_start_screen()
			RUNNING:
				pass


func load_high_score():
	var score
	var save_file = File.new()
	if save_file.file_exists("user://savefile.save"):
		save_file.open("user://savefile.save", File.READ)
		score = int(save_file.get_line())
		save_file.close()
	return score
	

func save_high_score():
	var save_file = File.new()
	save_file.open("user://savefile.save", File.WRITE)
	save_file.store_line(str(high_score))
	save_file.close()


func go_to_start_screen():
	state = TITLE
	$GUI.show_title(high_score)


func start_game():
	level = 1
	spawn_rate = 15
	spawn_counter = spawn_rate
	score = 0
	
	generate_map()

	
	$GUI.show_game(level)
	$GUI.update_score(score)
	
	state = RUNNING


func generate_map():
	clear_level()
	$Map.generate()
	create_player(start_hp)
	create_monsters()
	create_door()
	create_treasure()


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


func create_door():
	var t = Tile.get_random(Tile.type.FLOOR)
	while Monsters.get_monster_at(t):
		t = Tile.get_random(Tile.type.FLOOR, Map.level) 
	Door = door_scene.instance()
	Door.map_pos = t
	Door.position = Util.map_to_pixel(Door.map_pos)
	add_child(Door)
	
	
func create_treasure():
	var taken_pos = []
	for i in range(num_treasure):
		var t_pos = Tile.get_random(Tile.type.FLOOR)
		while t_pos == Door.map_pos or t_pos == Player.map_pos or Treasure.has_coin(t_pos):
			t_pos = Tile.get_random(Tile.type.FLOOR)
		var t = coin_scene.instance()
		t.map_pos = t_pos
		t.position = Util.map_to_pixel(t_pos)
		Treasure.add_child(t)
		


func on_door():
	return Player.map_pos == Door.map_pos


func clear_level():
	if Tomb:
		Tomb.queue_free()
		Tomb = null
	if Door:
		Door.queue_free()
		Door = null
	if Monsters.get_child_count() > 0:
		Monsters.clear_all()
	if Vortices.get_child_count() > 0:
		Vortices.clear_all()
	Player = null
	Treasure.clear_coins()


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
			if monster.is_in_group("player"):
				if on_door():
					load_next_level()
					return
				if Treasure.has_coin(Player.map_pos):
					Treasure.grab_coin(Player.map_pos)
		else:
			if monster.is_in_group("player") != monster_at_tile.is_in_group("player"):
				if monster_at_tile.appeared:
					monster.attacked_this_turn = true
					monster_at_tile.stunned = true
					monster_at_tile.hit(1)
	if monster.is_in_group("player"):
		update_spawn_counter()
		update_entities()
	

func load_next_level():
	level += 1
	if level > num_levels:
		state = DEAD
	else:
		spawn_rate = 15
		spawn_counter = spawn_rate
		start_hp = min(3, Player.hp + 1)
		
		generate_map()

		$GUI.show_game(level)


func update_high_score():
	if not high_score or score > high_score:
		high_score = score
		save_high_score()
		

func update_entities():
	Monsters.tick()
	Vortices.tick()
	Door.animate()


func _on_Monster_modified_map(tile_pos, tile_type):
	Map.change_tile(tile_pos, tile_type)


func _on_Monster_died(monster, pos):
	if monster.is_in_group("player"):
		Tomb = tomb_scene.instance()
		Tomb.position = pos
		add_child(Tomb)
		yield(get_tree().create_timer(0.3), "timeout")
		state = DEAD
		print(pos)


func _on_Treasure_coin_grabbed():
	score += 1
	$GUI.update_score(score)
