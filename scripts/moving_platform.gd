@tool
class_name MovingPlatform
extends AnimatableBody2D

signal movement_started()
signal movement_stopped()
signal arrived(target: Vector2)

@export var speed: float = 64 # pixels / second
@export var move_in_editor: bool = false

var _is_moving: bool:
	set(value):
		if (value && !_is_moving):
			movement_started.emit()
		elif (!value && _is_moving):
			movement_stopped.emit()
		_is_moving = value

var _target: Vector2

func move_to(target: Vector2):
	if target != position:
		_target = target
		_is_moving = true

func _physics_process(delta):
	if not _is_moving or not move_in_editor:
		return

	var vector_to_target = (_target - position)
	var distance_to_target = vector_to_target.length()
	var direction = vector_to_target.normalized()
	
	var step_distance = delta * speed
	position += step_distance * direction
	if distance_to_target < step_distance:
		position = _target
		
		_is_moving = false
		arrived.emit()
