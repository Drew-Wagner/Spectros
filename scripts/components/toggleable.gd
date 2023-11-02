@tool
class_name Toggleable
extends Node

signal toggled()
signal switched_on()
signal switched_off()
signal physics_process_on(delta: float)
signal physics_process_off(delta: float)


## Is this component connected to the global OnOff toggle signal?
@export var is_player_toggleable: bool = true:
	set(value):
		is_player_toggleable = value
		if Engine.is_editor_hint(): # OnOff global not available in editor
			return
		if not is_node_ready():
			await ready
		var already_connected = OnOff.toggle.is_connected(toggle)
		if is_player_toggleable:
			if not already_connected:
				OnOff.toggle.connect(toggle)
		else:
			if already_connected:
				OnOff.toggle.disconnect(toggle)

## Sets the initial state of the toggle.
@export var is_on: bool = false:
	set(value):
		if value and not is_on:
			switched_on.emit()
			toggled.emit()
		elif not value and is_on:
			switched_off.emit()
			toggled.emit()
		is_on = value

func _ready():
	if is_player_toggleable:
		OnOff.toggle.connect(toggle)


## Toggles the element between on or off states
func toggle():
	is_on = !is_on

func _physics_process(delta):
	if is_on:
		physics_process_on.emit(delta)
	else:
		physics_process_off.emit(delta)
