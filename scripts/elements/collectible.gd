class_name Collectible
extends Node2D

signal collected(collectible: Collectible)

@export var reward_sound: AudioStream
@export var reward_sound_random_array: Array[AudioStream]
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

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

		var sound_length = reward_sound.get_length()
		if reward_sound:
			audio_stream_player_2d.get_stream_playback().play_stream(reward_sound)
		if reward_sound_random_array.size() > 0:
			var random_sound = reward_sound_random_array.pick_random()
			sound_length = maxf(sound_length, random_sound.get_length())
			audio_stream_player_2d.get_stream_playback().play_stream(random_sound)
		
		await get_tree().create_timer(sound_length).timeout
		queue_free()

