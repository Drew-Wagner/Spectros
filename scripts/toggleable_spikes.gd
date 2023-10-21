extends Toggleable

@export var spikes_scene: PackedScene
@onready var spikes_off: Sprite2D = $SpikesOff

var spikes: Area2D

# Called when the element switches from off -> on
func _on_switch_on():
	_add_spikes()
	spikes_off.hide()


# Called when the element switches from on -> off
func _on_switch_off():
	spikes.queue_free()
	spikes_off.show()


func _add_spikes():
	spikes = spikes_scene.instantiate() as Area2D
	add_child(spikes)
