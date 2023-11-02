extends MarginContainer
class_name BoneCollection

@export var bone_icon_scene: PackedScene

@onready var hbox = $HBoxContainer

var bone_amount: int
var bone_icons: Array[BoneIcon]
var bones_collected_amount = 0
var bones_in_collection_progress = 0

func on_bone_count_updated(value: int):
	bone_amount = value
	bones_collected_amount = 0
	bones_in_collection_progress = 0
	
	for bone in bone_icons:
		bone.queue_free()
	
	bone_icons = []
	
	for i in value:
		var bone_icon_instance = bone_icon_scene.instantiate()
		hbox.add_child(bone_icon_instance)
		bone_icons.append(bone_icon_instance)


func on_move_bone_to_collection(bone: BoneCollected):
	var bone_index = bone_amount - bones_collected_amount - 1 - bones_in_collection_progress
	var slot = bone_icons[bone_index]
	bones_in_collection_progress += 1
	bone.move_to_collection_slot(slot)

func bone_arrived_to_collection():
	_turn_on_bone_by_number(bones_collected_amount)
	bones_collected_amount += 1
	bones_in_collection_progress -= 1


func _turn_on_bone_by_number(number: int):
	var bone_index = bone_amount - number - 1
	
	if bone_index < 0:
		return
		
	bone_icons[bone_index].set_full_texture()
