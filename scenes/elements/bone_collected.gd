extends Node2D
class_name BoneCollected

signal bone_arrived_to_collection()

const SPEED = 1200
const TARGET_OFFSET = Vector2(-3, -4)
const TARGET_SCALE = Vector2(1.85,  1.85)
const TARGET_ROTATION = -0.73 - (3 * TAU)

var target_position: Vector2
var target_direction: Vector2
var initial_distance: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_position == null:
		return
	
	var distance = (target_position - global_position).length()
	var movement = target_direction * delta * SPEED
	if distance < movement.length():
		global_position = target_position
		bone_arrived_to_collection.emit()
		queue_free()
		return
	
	global_position += movement
	var move_percent = (initial_distance - distance) / initial_distance
	scale = lerp(Vector2.ONE, TARGET_SCALE, move_percent)
	rotation = lerpf(0, TARGET_ROTATION, move_percent)


func move_to_collection_slot(slot: BoneIcon):
	var slot_size = slot.texture.get_size()
	target_position = slot.global_position
	target_position += (slot_size / 2)
	target_position += TARGET_OFFSET
	
	target_direction = (target_position - global_position).normalized()
	initial_distance = (target_position - global_position).length()
