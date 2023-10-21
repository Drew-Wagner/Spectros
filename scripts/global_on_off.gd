extends Node

signal toggle()

func _process(delta):
	if Input.is_action_just_pressed("toggle") or Input.is_action_just_released("toggle"):
		toggle.emit()

