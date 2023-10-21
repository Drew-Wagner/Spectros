class_name MainCharacter
extends "res://scripts/move_and_reflect.gd"

signal killed()

func kill():
	killed.emit()
