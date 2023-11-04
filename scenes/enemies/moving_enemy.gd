extends MoveAndReflect
class_name MovingEnemy

@onready var sprite: Sprite2D = $Sprite2D

func kill():
	if is_queued_for_deletion():
		return false
	
	self.queue_free()
	return true


func _on_squished():
	kill()
