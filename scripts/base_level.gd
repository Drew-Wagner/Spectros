class_name BaseLevel
extends Node2D

signal completed()
signal bone_collected()
signal all_bones_collected()
signal bone_count_updated(value: int)

var bones_remaining: int

var spawn_point: Vector2:
	get:
		if %SpawnPoint:
			return %SpawnPoint.global_position
		
		return Vector2.ZERO

func _ready():
	var bones = get_tree().get_nodes_in_group("bones")
	var n_bones = 0
	for bone in bones:
		if bone is Collectible:
			n_bones += 1
			bone.collected.connect(_on_bone_collected)
	
	bones_remaining = n_bones
	bone_count_updated.emit(bones_remaining)

func _on_bone_collected():
	bones_remaining -= 1
	bone_collected.emit()
	if bones_remaining == 0:
		all_bones_collected.emit()

func _on_finish_area_body_entered(body):
	if not body is MainCharacter:
		return
  
	if bones_remaining > 0:
		return
	
	completed.emit()


func _on_level_area_body_exited(body):
	if body is MainCharacter and not self.is_queued_for_deletion():
		print("fell out of world")
		body.kill()
