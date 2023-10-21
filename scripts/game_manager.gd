extends Node2D

@export var levels: Array[PackedScene]
@export var level_index: int = 0

var level: BaseLevel

@onready var count_down: Label = %CountDown

@export var toggle_sounds: Array[AudioStream]
@export var win_sound: AudioStream
@export var lose_sound: AudioStream
@export var is_countdown_enabled: bool

var toggle_sound_index = 0
var level_time = 0

@onready var level_label: Label = %LevelLabel
@onready var time_label: Label = %TimeLabel
@onready var audioStreamPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var main_character: MainCharacter = $MainCharacter

var spawn_location: Vector2
var is_paused: bool

func _ready():
	OnOff.toggle.connect(play_toggle_sound)
	start_level()

func next_level():
	audioStreamPlayer.stream = win_sound
	audioStreamPlayer.play()

	level_index += 1
	if level_index == levels.size():
		print("No more levels")
		return

	start_level()

func start_level():
	if level_index >= levels.size():
		return
	
	if level:
		level.queue_free()
		
	level_time = 0

	# Spawn in level
	level = levels[level_index].instantiate() as BaseLevel
	level.completed.connect(next_level)

	Callable(add_child).call_deferred(level)
	
	level_label.text = "Level %s" % str(level_index + 1)
	time_label.text = "00:00.00"
	
	respawn()
	# Countdown
	if is_countdown_enabled:
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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_paused:
		level_time += delta
		
		var minutes = int(level_time / 60)
		var remainingSeconds = int(level_time) % 60
		var fraction = int((level_time - int(level_time)) * 100)
		
		var formattedMinutes = "%02d" % minutes
		var formattedSeconds = "%02d" % remainingSeconds
		var formattedFraction = "%02d" % fraction
		
		var formattedTime = formattedMinutes + ":" + formattedSeconds + "." + formattedFraction
		
		time_label.text = formattedTime

func play_toggle_sound():
	audioStreamPlayer.stream = toggle_sounds[toggle_sound_index]
	audioStreamPlayer.play()

	toggle_sound_index = (toggle_sound_index + 1) % toggle_sounds.size()

func respawn():
	# Spawn in character
	main_character.set_deferred("global_position", level.spawn_point)
	main_character.velocity = Vector2.ZERO

func pause():
	is_paused = true
	propagate_call("set_physics_process", [false])
	OnOff.paused = true

func unpause():
	is_paused = false
	OnOff.paused = false
	propagate_call("set_physics_process", [true])

func on_character_die():
	audioStreamPlayer.stream = lose_sound
	audioStreamPlayer.play()

	start_level()
	
