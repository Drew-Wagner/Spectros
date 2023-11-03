extends TextureRect
class_name BoneIcon

@export var bone_collected_scene: PackedScene
@export var bone_full_texture: Texture2D
@onready var particles: GPUParticles2D = $GPUParticles2D

const SPEED = 1200
const TARGET_OFFSET = Vector2(-3, -4)
const TARGET_SCALE = Vector2(1.85,  1.85)
const TARGET_ROTATION = -0.73 - (3 * TAU)

var target_position: Vector2
var target_direction: Vector2
var initial_distance: float

var bone_collected_instance: Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bone_collected_instance == null:
		return
	
	var distance = (target_position - bone_collected_instance.global_position).length()
	var movement = target_direction * delta * SPEED
	if distance < movement.length():
		bone_collected_instance.global_position = target_position
		set_full_texture()
		bone_collected_instance.queue_free()
		bone_collected_instance = null
		return
	
	bone_collected_instance.global_position += movement
	var move_percent = (initial_distance - distance) / initial_distance
	bone_collected_instance.scale = lerp(Vector2.ONE, TARGET_SCALE, move_percent)
	bone_collected_instance.rotation = lerpf(0, TARGET_ROTATION, move_percent)


func start_collect_bone(bone: Collectible):
	var bone_position = bone.global_position
	bone_collected_instance = bone_collected_scene.instantiate() as Node2D 
	add_child(bone_collected_instance)
	bone_collected_instance.global_position = bone_position
	
	var bone_icon_size = texture.get_size()
	target_position = global_position
	target_position += (bone_icon_size / 2)
	target_position += TARGET_OFFSET
	
	target_direction = (target_position - bone_position).normalized()
	initial_distance = (target_position - bone_position).length()


func set_full_texture():
	texture = bone_full_texture
	particles.emitting  = true
