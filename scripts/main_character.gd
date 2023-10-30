class_name MainCharacter
extends MoveAndReflect

signal killed()

var is_killed: bool = false

func kill():
	if not is_killed:
		is_killed = true
		killed.emit()
		self.queue_free()
		return true
	
	return false


func _on_squished():
	kill()
