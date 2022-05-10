extends Node2D

var player_scene = preload("res://scenes/Player.tscn")
var bird_scene = preload("res://scenes/Bird.tscn")
var snake_scene = preload("res://Snake.tscn")
var tank_scene = preload("res://Tank.tscn")
var eater_scene = preload("res://Eater.tscn")
var jester_scene = preload("res://Jester.tscn")

var monster_scenes = [bird_scene, snake_scene, tank_scene, eater_scene, jester_scene]
var level = 1


onready var Map = $Map
onready var Monsters = $Monsters
onready var Player = player_scene.instance()


func _ready():
	create_player()
	create_monsters()


func create_player():
	var p_start_pos = Tile.get_random(Tile.type.FLOOR, Map.level)
	Player.initialize(p_start_pos, self)
	
	Monsters.add_child(Player)


func create_monsters():
	var num_monsters = level + 1
	for i in range(num_monsters):
		var monster_index = randi() % monster_scenes.size()
		var m = monster_scenes[monster_index].instance()
		var m_start_pos = Tile.get_random(Tile.type.FLOOR, Map.level)	
		
		while Monsters.get_monster_at(m_start_pos):
			m_start_pos = Tile.get_random(Tile.type.FLOOR, Map.level) 
		
		m.initialize(m_start_pos, self)	
		Monsters.add_child(m)



func _on_Monster_tried_move(monster, target_pos):
	if Tile.is_passable(target_pos, Map.level):
		var monster_at_tile = Monsters.get_monster_at(target_pos)
		if not monster_at_tile:
			monster.move(target_pos)
		else:
			if monster.is_in_group("player") != monster_at_tile.is_in_group("player"):
				monster.attacked_this_turn = true
				monster_at_tile.stunned = true
				monster_at_tile.hit(1)
	if monster.is_in_group("player"):
		Monsters.tick()
		
func _on_Monster_modified_map(tile_pos, tile_type):
	Map.change_tile(tile_pos, tile_type)
		

	

