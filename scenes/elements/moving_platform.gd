@tool
extends ToggleMovingPlatform

@export_enum("Up", "Right", "Down", "Left") var orientation: int:
	set(value):
		orientation = value
		_set_orientation()

enum Orientation {
	Up,
	Right,
	Down,
	Left
}


func _set_orientation():
	match orientation:
		Orientation.Up:
			rotation = 0
		
		Orientation.Right:
			rotation = deg_to_rad(90)
		
		Orientation.Down:
			rotation = deg_to_rad(180)
		
		Orientation.Left:
			rotation = deg_to_rad(-90)
