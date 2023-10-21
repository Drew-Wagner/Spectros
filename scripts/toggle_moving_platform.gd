@tool
class_name ToggleMovingPlatform
extends Toggleable

@export var moving_platform: MovingPlatform
@export var on_position: Vector2
@export var off_position: Vector2

func _ready():
	super()
	if not moving_platform:
		moving_platform = get_node("MovingPlatform")

func _get_configuration_warnings():
	super()
	if not (moving_platform or get_node("MovingPlatform")):
		return "Node requires a MovingPlatform"

# Called when the element switches from off -> on
func _on_switch_on():
	moving_platform.move_to(on_position)

# Called when the element switches from on -> off
func _on_switch_off():
	moving_platform.move_to(off_position)
