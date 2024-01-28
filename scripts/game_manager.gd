extends Node2D

@export var levels: Array[PackedScene]
@export var level_index: int = 0

@onready var bone_collection: BoneCollection = $%BoneCollection

var level: BaseLevel

signal _toggle_released()
signal _toggle_pressed()
signal game_end()
signal level_start()
signal level_end()
signal died()

@export var main_character_scene: PackedScene
var level_time = 0

@onready var level_label: Label = %LevelLabel
@onready var time_label: Label = %TimeLabel
@onready var scene_transition: AnimationPlayer = %SceneTransitionAnimPlayer
@onready var transition_particles: Node2D = %TransitionParticles

var main_character: MainCharacter
var spawn_location: Vector2
var is_paused: bool

func _ready():
	%TransitionOverlay.show()
	start_level()

func next_level():
	level_end.emit()

	level_index += 1
	start_level()

func start_level():
	pause()
	if level:
		scene_transition.play("fade")
		if level_index >= levels.size():
			await scene_transition.animation_finished
			game_end.emit()
			return
		
		await scene_transition.animation_finished
		level.queue_free()
		await level.tree_exited
	
	level_time = 0

	# Spawn in level
	level = levels[level_index].instantiate() as BaseLevel
	level.completed.connect(next_level)
	level.bone_count_updated.connect(bone_collection.on_bone_count_updated)
	level.bone_collected.connect(bone_collection.on_bone_collected)

	Callable($LevelHolder.add_child).call_deferred(level)
	Callable(level.propagate_call).call_deferred("set_physics_process", [false])	
	
	level_label.text = "Level %s" % str(level_index + 1)
	time_label.text = "00:00.00"
	
	respawn()
	pause()
	
	%SplashLabel.show()
	
	scene_transition.play_backwards("fade")
	await scene_transition.animation_finished
	
	await _toggle_pressed
	await _toggle_released
	%SplashLabel.hide()
	level_start.emit()
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
	else:
		if Input.is_action_just_pressed("toggle"):
			_toggle_pressed.emit()
		if Input.is_action_just_released("toggle"):
			_toggle_released.emit()

func respawn():
	if main_character and is_instance_valid(main_character):
		main_character.queue_free()

	main_character = main_character_scene.instantiate() as MainCharacter
	main_character.killed.connect(_emit_died)
	main_character.global_position = level.spawn_point
	add_child(main_character)

func _emit_died():
	died.emit()

func pause():
	is_paused = true
	propagate_call("set_physics_process", [false])
	OnOff.paused = true

func unpause():
	is_paused = false
	OnOff.paused = false
	propagate_call("set_physics_process", [true])

func _on_died():
	transition_particles.propagate_call("set_emitting", [true])
	start_level()
