extends Node2D

@export var levels: Array[PackedScene]
@export var level_index: int = 0

var level: BaseLevel


@export var toggle_sounds: Array[AudioStream]
@export var win_sound: AudioStream
@export var lose_sound: AudioStream
@export var countdown_seconds: int = 3
@export var is_countdown_enabled: bool
@export var main_character_scene: PackedScene
var toggle_sound_index = 0
var level_time = 0

@onready var count_down: Label = %CountDown
@onready var level_label: Label = %LevelLabel
@onready var time_label: Label = %TimeLabel
@onready var audioStreamPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var scene_transition: AnimationPlayer = %SceneTransitionAnimPlayer

var main_character: MainCharacter
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
	if level:
		level.queue_free()
		scene_transition.play("fade")
		await scene_transition.animation_finished
	
	level_time = 0	

	if level_index >= levels.size():
		return

	# Spawn in level
	level = levels[level_index].instantiate() as BaseLevel
	level.completed.connect(next_level)

	Callable(add_child).call_deferred(level)
	
	level_label.text = "Level %s" % str(level_index + 1)
	time_label.text = "00:00.00"
	
	respawn()
	pause()	
	
	scene_transition.play_backwards("fade")
	await scene_transition.animation_finished

	# Countdown
	if is_countdown_enabled:
		count_down.show()
		for i in range(countdown_seconds, 0, -1):
			count_down.text = str(i)
			await get_tree().create_timer(1).timeout
		
	count_down.text = ""
	count_down.hide()
	unpause()


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
	main_character = main_character_scene.instantiate() as MainCharacter
	main_character.killed.connect(on_character_die)
	main_character.global_position = level.spawn_point
	add_child(main_character)

func pause():
	is_paused = true
	propagate_call("set_physics_process", [false])
	OnOff.paused = true

func unpause():
	is_paused = false
	OnOff.paused = false
	propagate_call("set_physics_process", [true])

func on_character_die():
	print("die")
	audioStreamPlayer.stream = lose_sound
	audioStreamPlayer.play()

	start_level()
	
