extends MoveAndReflect
class_name MovingEnemy


func kill():
	self.queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("kill") and body.is_in_group("player"):
		body.kill()
