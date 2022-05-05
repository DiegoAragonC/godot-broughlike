extends Node2D

signal tried_move(tile_pos)

var step_size = Globals.TILE_SIZE
var start_pos
var map_pos

func initialize():
	move(start_pos)
	
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
		try_move(step_dir)
		animate()


func animate():
	var current_frame = $Sprite.frame
	var number_of_frames = $Sprite.hframes
	$Sprite.frame = (current_frame + 1) % number_of_frames


func try_move(step_dir):
	var target_pos = map_pos + step_dir
	emit_signal("tried_move", target_pos)


func move(tile_pos):
	map_pos = tile_pos
	global_position = Util.map_to_pixel(map_pos)
