extends Node2D

@export var levels: Array[PackedScene]
@export var level_index: int = 0

var level: BaseLevel

@onready var count_down: Label = %CountDown

@export var toggle_sounds: Array[AudioStream]
var toggle_sound_index = 0

@onready var audioStreamPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var mainCharacter: MainCharacter = $MainCharacter

var spawn_location: Vector2

func _ready():
	start_level()

func start_level():
	if level_index >= levels.size():
		return
	
	if level:
		level.queue_free()

	# Spawn in level
	level = levels[level_index].instantiate() as BaseLevel
	add_child(level)
	
	respawn()
	# Countdown
	pause()
	count_down.show()
	count_down.text = "3"
	get_tree().create_timer(1).timeout.connect(
		func ():
			count_down.text = "2")
	get_tree().create_timer(2).timeout.connect(
		func ():
			count_down.text = "1")
			
	get_tree().create_timer(3.0).timeout.connect(
		func():
			count_down.text = ""
			count_down.hide()
			unpause()
	)
	
	OnOff.toggle.connect(play_toggle_sound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_toggle_sound():
	audioStreamPlayer.stream = toggle_sounds[toggle_sound_index]
	audioStreamPlayer.play()

	toggle_sound_index = (toggle_sound_index + 1) % toggle_sounds.size()

func respawn():
	# Spawn in character
	mainCharacter.set_deferred("global_position", level.spawn_point)

func pause():
	propagate_call("set_physics_process", [false])
	OnOff.paused = true

func unpause():
	OnOff.paused = false
	propagate_call("set_physics_process", [true])
