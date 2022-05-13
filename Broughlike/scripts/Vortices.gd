extends Node

func tick():
	for v in get_children():
		v.update()


func clear_all():
	for v in get_children():
		v.queue_free()
