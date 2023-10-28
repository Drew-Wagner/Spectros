@tool
extends Area2D

const RADIUS_OUT_OPEN = 55
const RADIUS_IN_OPEN = 50

const RADIUS_OUT_CLOSED = 5
const RADIUS_IN_CLOSED = 2

@onready var ring_particles: GPUParticles2D = $RingParticles
@onready var bone_particles: GPUParticles2D = $BoneParticles
@onready var sprite_background: Sprite2D = $Sprite2D

@export var is_open: bool:
	set(value): 
		is_open = value
		if is_open:
			ring_particles.process_material.emission_ring_radius = RADIUS_OUT_OPEN
			ring_particles.process_material.emission_ring_inner_radius = RADIUS_IN_OPEN
			bone_particles.show()
			sprite_background.show()
		else:
			ring_particles.process_material.emission_ring_radius = RADIUS_OUT_CLOSED
			ring_particles.process_material.emission_ring_inner_radius = RADIUS_IN_CLOSED
			bone_particles.hide()
			sprite_background.hide()

func open():
	is_open = true
