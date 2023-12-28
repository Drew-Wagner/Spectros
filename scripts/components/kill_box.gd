class_name KillBox
extends Area2D
## Kills all killable bodies which enter it (unless in an ignored group).
##
## If provided a CollisionShape2D as a child,
## will call the `kill() -> bool`" method on any body which enters
## the area and is not in one of the `ignore_groups`
##
## The `kill() -> bool` method should do any death logic, destroy the body
## and return true if the body was killed, and false if it was not (for example
## if the body has already been killed, then a subsequent call to `kill` should
## return false)
##
## NOTE: If the parent also is a PhysicsBody2D and has
## a non-area CollisionShape2D, then make sure that that
## shape does not prevent a body from entering this component's
## collision shape (i.e this component's collision shape should
## be larger than the one used for physics collisions).

## Emitted each time a body is killed.
signal body_killed(body: Node2D)

## Whether or not the kill box is enabled or not
##
## When disabled, bodies which enter the area will not be killed.
@export var is_enabled: bool = true:
	set(value):
		is_enabled = value
		monitoring = value

## Bodies in any of these groups will not be killed.
@export var ignore_groups: Array[StringName]

func _on_body_entered(body: Node2D):
	if not is_enabled:
		return

	for group in ignore_groups:
		if body.is_in_group(group):
			return

	if body.has_method("kill") and body.get_parent() != get_parent():
		if body.kill():
			body_killed.emit(body)
