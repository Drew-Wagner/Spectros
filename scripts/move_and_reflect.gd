@tool # allows the "isLookingRight" code to run in the editor
class_name MoveAndReflect
extends CharacterBody2D

@onready var sprite2D: Node2D = $Sprite2D

@export var moveSpeed: float = 32
@export var isLookingRight: bool = true:
	set (value):
		if sprite2D and (isLookingRight && !value or !isLookingRight && value):
			if sprite2D.has_method("flip_h"):
				sprite2D.flip_h = !sprite2D.flip_h
			else:
				for child in sprite2D.get_children():
					if child.has_method("flip_h"):
						child.flip_h = !child.flip_h
		isLookingRight = value
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var in_stasis = false
var was_on_wall_last_frame = false

func _physics_process(delta):
	if Engine.is_editor_hint(): return  # disables movement in the editor
	
	if in_stasis:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	if is_on_wall():
		if was_on_wall_last_frame:
			isLookingRight = !isLookingRight
		was_on_wall_last_frame = true
	else:
		was_on_wall_last_frame = false

	var direction = 1 if isLookingRight else -1
	
	if is_on_floor():
		velocity.x = direction * moveSpeed
	else:
		velocity.x = lerpf(velocity.x, 0, delta)
	
	move_and_slide()

func set_in_stasis(active: bool):
	in_stasis = active
