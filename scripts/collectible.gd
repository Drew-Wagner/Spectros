class_name Collectible
extends Node2D

signal collected()

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		hide()
		collected.emit()

		audio_stream_player_2d.play()
		await audio_stream_player_2d.finished
		queue_free()

