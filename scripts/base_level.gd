class_name BaseLevel
extends Node2D

signal completed()
signal bone_collected()
signal all_bones_collected()
signal bone_count_updated(value: int)
signal move_bone_to_collection(bone: BoneCollected)
signal bone_arrived_to_collection()

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
			bone.move_bone_to_collection_event.connect(_move_bone_to_collection)
	
	bones_remaining = n_bones
	bone_count_updated.emit(bones_remaining)
	
	_connect_listeners()
	_connect_finish_area()

func _on_bone_collected():
	bones_remaining -= 1
	bone_collected.emit()
	if bones_remaining == 0:
		all_bones_collected.emit()

func _move_bone_to_collection(bone: BoneCollected):
	bone.bone_arrived_to_collection.connect(on_bone_arrived_to_collection)
	move_bone_to_collection.emit(bone)


func on_bone_arrived_to_collection():
	bone_arrived_to_collection.emit()

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

func _connect_listeners():
	# Connect "on_all_bones collected" listeners .
	var all_bones_collected_listeners = get_tree().get_nodes_in_group("all_bones_collected_listeners")
	for listener in all_bones_collected_listeners:
		if listener.has_method("on_all_bones_collected"):
			all_bones_collected.connect(listener.on_all_bones_collected)

func _connect_finish_area():
	var finish_area = get_tree().get_first_node_in_group("finish_area") as Area2D
	finish_area.body_entered.connect(_on_finish_area_body_entered)
