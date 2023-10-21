class_name MainCharacter
extends "res://scripts/move_and_reflect.gd"

signal killed()

var is_killed: bool = false

func kill():
	if not is_killed:
		is_killed = true
		killed.emit()
		self.queue_free()

func _physics_process(delta):
	super(delta)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_depth() > 8:
			kill()
			return
