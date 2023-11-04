extends Sprite2D
class_name DeathAnimationSprite

const SPEED = 200
var time_passed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	global_position += Vector2(cos(3 * time_passed) * 3 * SPEED * delta, -SPEED * delta)
	if global_position.y < -50:
		queue_free()
