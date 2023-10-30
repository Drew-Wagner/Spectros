extends MoveAndReflect
class_name MovingEnemy

func kill():
	if is_queued_for_deletion():
		return false

	self.queue_free()
	return true

func _on_squished():
	kill()
