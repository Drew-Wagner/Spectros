@tool
extends Toggleable

@export var pull_speed: float = 512 # pixels / sec
@onready var sprite: Sprite2D = $Sprite2D
@onready var pull_target: Marker2D = $PullTarget
var bodies_in_area: Array[Node2D]

func _on_area_2d_body_entered(body):
	if body.has_method("set_in_stasis"):
		bodies_in_area.append(body)
		
		if is_on:
			body.set_in_stasis(true)


func _on_area_2d_body_exited(body):
	if body.has_method("set_in_stasis"):
		bodies_in_area.erase(body)
		
		if is_on:
			body.set_in_stasis(false)                   

func _on_switch_on():
	sprite.show()
	for body in bodies_in_area:
		body.set_in_stasis(true)

func _on_switch_off():
	sprite.hide()
	for body in bodies_in_area:
		body.set_in_stasis(false)

func _physics_process_on(delta):
	for body in bodies_in_area:
		var offset = (pull_target.global_position - body.global_position)
		var position_change = offset.normalized() * pull_speed * delta
		if position_change.length_squared() > offset.length_squared():
			position_change = offset

		body.set_deferred("global_position", body.global_position + position_change) 
