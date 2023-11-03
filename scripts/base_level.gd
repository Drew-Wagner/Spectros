@tool
class_name BaseLevel
extends Node2D

signal completed()
signal bone_collected(bone: Collectible)
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
		if bone is Collectible and not Engine.is_editor_hint():
			n_bones += 1
			bone.collected.connect(_on_bone_collected)
	
	bones_remaining = n_bones
	bone_count_updated.emit(bones_remaining)
	
	_connect_listeners()
	_connect_finish_area()

func _on_bone_collected(bone: Collectible):
	bones_remaining -= 1
	bone_collected.emit(bone)
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


func _draw():
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2(64, 64),Vector2(1792, 960)), Color.RED, false, 2.0)
		draw_rect(Rect2(Vector2(1408, 576),Vector2(320, 448)), Color.HOT_PINK, false, 2.0)
