extends MoveAndReflect
class_name MovingEnemy


func kill():
	self.queue_free()


func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		body.kill()

func _on_squished():
	kill()
