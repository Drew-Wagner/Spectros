@tool # allows the "isLookingRight" code to run in the editor
extends CharacterBody2D

@onready var sprite2D: Sprite2D = $Sprite2D

@export var moveSpeed: float = 32
@export var isLookingRight: bool = true:
	set (value):
		if sprite2D and (isLookingRight && !value or !isLookingRight && value):
			sprite2D.flip_h = !sprite2D.flip_h
		isLookingRight = value
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if Engine.is_editor_hint(): return  # disables movement in the editor

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		isLookingRight = !isLookingRight

	var direction = 1 if isLookingRight else -1
	velocity.x = direction * moveSpeed

	move_and_slide()