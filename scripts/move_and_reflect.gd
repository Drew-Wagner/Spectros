@tool # allows the "isLookingRight" code to run in the editor
class_name MoveAndReflect
extends CharacterBody2D

signal squished()

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

func _physics_process(delta):
	if Engine.is_editor_hint(): return  # disables movement in the editor
	
	if in_stasis:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	elif is_on_wall():
		var wall_normal = get_wall_normal()
		if get_real_velocity().dot(wall_normal) < 0:  # Velocity is pointing into the wall
			isLookingRight = !isLookingRight

	var direction = 1 if isLookingRight else -1
	
	if is_on_floor():
		velocity.x = direction * moveSpeed
	else:
		velocity.x = lerpf(velocity.x, 0, delta)
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_depth() > 16:	
			squished.emit()
			break


func set_in_stasis(active: bool):
	in_stasis = active
