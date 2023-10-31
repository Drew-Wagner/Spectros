@tool
extends Node2D

@export var is_player_toggleable: bool = false:
	set(value):
		is_player_toggleable = value
		if not is_node_ready():
			await ready
		_toggle.is_player_toggleable = is_player_toggleable
@export var is_on: bool = true:
	set(value):
		is_on = value
		if not is_node_ready():
			await ready
		_toggle.is_on = is_on

@export var off_texture: Texture2D
@export var on_texture: Texture2D

@onready var _toggle: Toggleable = $Toggle
@onready var _sprite2D: Sprite2D = $Sprite2D
@onready var _killbox: KillBox = $KillBox

func _on_toggle_switched_off():
	if not is_node_ready():
		await ready
	_sprite2D.texture = off_texture
	_killbox.is_enabled = false

func _on_toggle_switched_on():
	if not is_node_ready():
		await ready
	_sprite2D.texture = on_texture
	_killbox.is_enabled = true
	
func _draw():
	if Engine.is_editor_hint() and is_player_toggleable:
		_systemFont.font_names = ["monospace"]
		draw_string(_systemFont, 32 * Vector2.LEFT, "↕", HORIZONTAL_ALIGNMENT_CENTER, 64, 32)

static var _systemFont: SystemFont = SystemFont.new()
