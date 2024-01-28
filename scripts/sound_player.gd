class_name SoundPlayer
extends AudioStreamPlayer
@export var sounds: Array[Sound]

func _ready():
	stream = AudioStreamPolyphonic.new()
	play()

func play_by_name(name:StringName):
	var sound:Sound = find_sound(name)
	play_sound(sound)

func play_sound(sound:Sound):
	get_stream_playback().play_stream(sound.stream,0,sound.volume_db)

func play_all():
	for sound in sounds:
		play_sound(sound) 

func play_random():
	play_sound(sounds.pick_random()) 

func find_sound(name:StringName) -> Sound:
	for sound in sounds:
		if sound.name == name:
			return sound
	return null
