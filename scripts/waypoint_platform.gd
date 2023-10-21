@tool
class_name OscilatingPlatform
extends MovingPlatform

@export var waypoints: Array[Vector2]

func _find_first_waypoint():
	for i in (waypoints.size() - 1):
		var a = waypoints[i]
		var b = waypoints[i + 1]
		
		var seg = b - a
		var offset = position - a
		
		var dot = offset.normalized().dot(seg.normalized())
		if dot == 1 and offset.length_squared() < seg.length_squared():
			return b

	return null

func _ready():
	var first = _find_first_waypoint()
	if first == null:
		move_to(waypoints[0], true)
	else:
		move_to(first)

func _on_arrived(target: Vector2):
	var current_index = waypoints.find(target)
	var next_waypoint = waypoints[(current_index + 1) % waypoints.size()]
	move_to(next_waypoint)
