extends Node
class_name DeathAnimation

@export var sprite_texture: Texture2D
@export var scale_modifier_x: float = 1.0
@export var scale_modifier_y: float = 1.0

var death_animation_sprite_scene = preload("res://scenes/components/death_animation_sprite.tscn")

func _exit_tree():
	var death_animation_sprite_instance = death_animation_sprite_scene.instantiate() as Sprite2D
	get_tree().get_first_node_in_group("level").add_child.call_deferred(death_animation_sprite_instance)
	death_animation_sprite_instance.global_position = get_parent().global_position
	death_animation_sprite_instance.texture = sprite_texture
	death_animation_sprite_instance.scale = Vector2(scale_modifier_x, scale_modifier_y)
