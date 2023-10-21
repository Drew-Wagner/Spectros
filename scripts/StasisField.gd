@tool
extends Toggleable

@onready var sprite: Sprite2D = $Sprite2D
var bodies_in_area: Array[RigidBody2D]

func _on_area_2d_body_entered(body):
	if body.has_method("set_in_stasis"):
		bodies_in_area.append(body)
		
		if is_on:
			body.set_in_stasis(self)


func _on_area_2d_body_exited(body):
	if body.has_method("set_in_stasis"):
		bodies_in_area.erase(body)
		
		if is_on:
			body.set_in_stasis(null)

func _on_switch_on():
	sprite.show()
	for body in bodies_in_area:
		body.set_in_stasis(self)

func _on_switch_off():
	sprite.hide()
	for body in bodies_in_area:
		body.set_in_stasis(null)
