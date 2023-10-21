extends Node2D

@export var levels: Array[PackedScene]
@export var level_index: int = 0

var level: Node2D

@onready var count_down: Label = %CountDown


# Called when the node enters the scene tree for the first time.
func _ready():
	if level_index < levels.size():
		var level = levels[level_index].instantiate()
		add_child(level)
	
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
	pass


func pause():
	propagate_call("set_physics_process", [false])
	OnOff.paused = true

func unpause():
	OnOff.paused = false
	propagate_call("set_physics_process", [true])
