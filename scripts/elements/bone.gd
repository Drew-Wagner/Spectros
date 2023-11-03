extends Collectible
class_name CollectibleBone

#signal move_bone_to_collection_event(bone_collected: BoneCollected)

@export var bone_collected_scene: PackedScene
@onready var rotation_player: AnimationPlayer = $%RotationPlayer
@onready var hover_player: AnimationPlayer = $%HoverPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	randomize_animation_start_frame()


func randomize_animation_start_frame():
	var rotation_animation_length = rotation_player.get_animation("rotate").length
	var hover_animation_length = hover_player.get_animation("Hover").length
	
	var random_rotation_time = rotation_animation_length * randf()
	var random_hover_time = hover_animation_length * randf()
	
	rotation_player.advance(random_rotation_time)
	hover_player.advance(random_hover_time)
