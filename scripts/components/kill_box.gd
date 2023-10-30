class_name KillBox
extends Area2D

@export var ignore_groups: Array[StringName]

func _on_body_entered(body: Node2D):
	for group in ignore_groups:
		if body.is_in_group(group):
			return

	if body.has_method("kill") and body.get_parent() != get_parent():
		body.kill()
