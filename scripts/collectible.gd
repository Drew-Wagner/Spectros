class_name Collectible
extends Node2D

signal collected()

func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		collected.emit()
		queue_free()
