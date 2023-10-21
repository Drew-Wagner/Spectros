class_name BaseLevel
extends Node2D

signal completed()
signal all_bones_collected()

var bones_remaining

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

func _on_bone_collected():
	bones_remaining -= 1
	if bones_remaining == 0:
		all_bones_collected.emit()

func _on_finish_area_body_entered(body):
	if not body is MainCharacter:
		return

	if bones_remaining > 0:
		return
	
	completed.emit()
