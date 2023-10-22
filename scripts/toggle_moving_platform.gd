@tool
class_name ToggleMovingPlatform
extends Toggleable

@export var on_position: Vector2
@export var off_position: Vector2
@onready var moving_platform: MovingPlatform = $MovingPlatform

func _ready():
	super()
	if is_on:
		moving_platform.move_to(on_position, true)
	else:
		moving_platform.move_to(off_position, true)
	
func _get_configuration_warnings():
	if not (moving_platform or get_node("MovingPlatform")):
		return "Node requires a MovingPlatform"

# Called when the element switches from off -> on
func _on_switch_on():
	if !moving_platform:
		return

	moving_platform.move_to(on_position)

# Called when the element switches from on -> off
func _on_switch_off():
	if !moving_platform:
		return
	
	moving_platform.move_to(off_position)
