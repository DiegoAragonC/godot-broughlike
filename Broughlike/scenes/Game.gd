extends Node2D

var bird_scene = preload("res://scenes/Bird.tscn")
var player_scene = preload("res://scenes/Player.tscn")
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
		var b = bird_scene.instance()
		var m_start_pos = Tile.get_random(Tile.type.FLOOR, Map.level)	
		
		while Monsters.get_monster_at(m_start_pos):
			m_start_pos = Tile.get_random(Tile.type.FLOOR, Map.level) 
		
		b.initialize(m_start_pos, self)	
		Monsters.add_child(b)



func _on_Monster_tried_move(monster, target_pos):
	if Tile.is_passable(target_pos, Map.level) and not Monsters.get_monster_at(target_pos):
		monster.move(target_pos)
	if monster.is_in_group("player"):
		Monsters.tick()

