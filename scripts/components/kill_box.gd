class_name KillBox
extends Area2D
## Kills all killable bodies which enter it (unless in an ignored group).
##
## If provided a CollisionShape2D as a child,
## will call the "kill" method on any body which enters
## the area and is not in one of the `ignore_groups`
##
## NOTE: If the parent also is a PhysicsBody2D and has
## a non-area CollisionShape2D, then make sure that that
## shape does not prevent a body from entering this component's
## collision shape (i.e this component's collision shape should
## be larger than the one used for physics collisions).

## Bodies in any of these groups will not be killed.
@export var ignore_groups: Array[StringName]

func _on_body_entered(body: Node2D):
	for group in ignore_groups:
		if body.is_in_group(group):
			return

	if body.has_method("kill") and body.get_parent() != get_parent():
		body.kill()
