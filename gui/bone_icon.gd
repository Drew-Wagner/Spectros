extends TextureRect
class_name BoneIcon

@export var bone_full_texture: Texture2D
@onready var particles: GPUParticles2D = $GPUParticles2D

func set_full_texture():
	texture = bone_full_texture
	particles.emitting  = true
