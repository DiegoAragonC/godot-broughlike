extends "res://scripts/Monster.gd"

var tomb_scene = preload("res://scenes/Tomb.tscn")

func _ready():
	add_to_group("player")
	

func _input(event):
	var step_dir = Vector2()
	if event.is_action_pressed("left"):
		step_dir.x -= 1
	if event.is_action_pressed("right"):
		step_dir.x += 1
	if event.is_action_pressed("up"):
		step_dir.y -= 1
	if event.is_action_pressed("down"):
		step_dir.y += 1

	if step_dir != Vector2.ZERO:
		var target = map_pos + step_dir
		try_move(target)
		animate(step_dir.x)


func generate_tomb():
	var t = tomb_scene.instance()
	t.global_position = global_position
