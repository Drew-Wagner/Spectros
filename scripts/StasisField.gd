@tool
extends Toggleable

@export var pull_speed: float = 512 # pixels / sec
@onready var particles: GPUParticles2D = $GPUParticles2D
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
	particles.show()
	for body in bodies_in_area:
		body.set_in_stasis(true)

func _on_switch_off():
	particles.hide()
	for body in bodies_in_area:
		body.set_in_stasis(false)

func _physics_process_on(_delta):
	for body in bodies_in_area:
		if not body is CharacterBody2D:
			continue
		var direction = (pull_target.global_position - body.global_position).normalized()
		body.velocity = direction * pull_speed
		body.move_and_slide()
