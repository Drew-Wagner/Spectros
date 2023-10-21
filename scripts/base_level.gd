class_name BaseLevel
extends Node2D

signal completed()

var spawn_point: Vector2:
	get:
		if %SpawnPoint:

			return %SpawnPoint.global_position
		
		return Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
