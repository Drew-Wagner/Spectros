extends Node

signal toggle()

var paused: bool = false
		

func _process(_delta):
	if Input.is_action_just_pressed("toggle") or Input.is_action_just_released("toggle"):
		if not paused:
			toggle.emit()

