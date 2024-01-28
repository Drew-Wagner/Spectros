class_name Collectible
extends Node2D

signal collected(collectible: Collectible)
var is_collected = false

func _ready():
	pass

func _on_area_2d_body_entered(body):
	if is_collected:
		return
	
	if body is MainCharacter:
		is_collected = true
		hide()
		collected.emit(self)

		await get_tree().create_timer(1).timeout
		queue_free()

