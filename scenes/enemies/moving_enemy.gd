extends MoveAndReflect
class_name MovingEnemy

func kill():
	self.queue_free()

func _on_squished():
	kill()
