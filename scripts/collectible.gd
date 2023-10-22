class_name Collectible
extends Node2D

signal collected()

@export var reward_sound: AudioStream
@export var reward_sound_random_array: Array[AudioStream]
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		hide()
		collected.emit()

		if reward_sound:
			audio_stream_player_2d.play_stream(reward_sound)
		if reward_sound_random_array.size() > 0:
			audio_stream_player_2d.play_stream(reward_sound_random_array.pick_random())
			
		await audio_stream_player_2d.finished
		queue_free()

