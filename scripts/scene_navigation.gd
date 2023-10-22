class_name SceneNavigation
extends Node

func go_to(path: String):
	get_tree().change_scene_to_file(path)
