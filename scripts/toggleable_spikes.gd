extends Toggleable

@export var spikes_scene: PackedScene

var spikes: Area2D

# Called when the element switches from off -> on
func _on_switch_on():
	print("ON")
	_add_spikes()


# Called when the element switches from on -> off
func _on_switch_off():
	print("OFF")
	spikes.queue_free()


func _add_spikes():
	spikes = spikes_scene.instantiate() as Area2D
	add_child(spikes)
