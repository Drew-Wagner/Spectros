@tool
extends Toggleable

@export var pull_speed: float = 512 # pixels / sec
@export var stasis_range: float:# Grid units, can be fractions
	set(value):
		stasis_range = value
		_set_stasis_range.call_deferred()

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var pull_target: Marker2D = $PullTarget
@onready var stasis_area: Area2D = $Area2D

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


func _set_stasis_range():
	if stasis_area == null:
		stasis_area = $Area2D
	if particles == null:
		particles = $GPUParticles2D
	
	stasis_area.scale.y = stasis_range
	
	var process_material = particles.process_material as ParticleProcessMaterial
	process_material.emission_box_extents = Vector3(30, 30 * stasis_range, 1)
	particles.position = Vector2(0, -30 * stasis_range)
	if stasis_range > 4:
		particles.amount = 50 * sqrt(stasis_range)
	else:
		particles.amount = 50
