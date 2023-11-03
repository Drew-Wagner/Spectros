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


func on_bone_collected(bone: Collectible):
	var bone_index = bone_amount - bones_collected_amount - 1 - bones_in_collection_progress
	var bone_icon = bone_icons[bone_index]
	bone_icon.start_collect_bone(bone)
	bones_collected_amount += 1
