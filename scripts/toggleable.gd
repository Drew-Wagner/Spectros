class_name Toggleable
extends Node


@export var is_on: bool = false

# Called when the element switches from off -> on
func _on_switch_on():
	pass

# Called when the element switches from on -> off
func _on_switch_off():
	pass

# Called each frame if the element is on
func _process_on(_delta):
	pass

# Called each frame if the element is off
func _process_off(_delta):
	pass

# Called each physics frame if the element is on
func _physics_process_on(_delta):
	pass

# Calld each physics frame if the element is off	
func _physics_process_off(_delta):
	pass

# Toggles the element on or off
func toggle():
	if is_on:
		_on_switch_off()
	else:
		_on_switch_on()
	is_on = !is_on

func _ready():
	OnOff.toggle.connect(toggle)

func _process(delta):
	if is_on:
		_process_on(delta)
	else:
		_process_off(delta)

func _physics_process(delta):
	if is_on:
		_physics_process_on(delta)
	else:
		_physics_process_off(delta)
