extends Toggleable

@export var spikes_scene: PackedScene
@onready var spikes_off: Sprite2D = $SpikesOff

var spikes: Node2D

# Called when the element switches from off -> on
func _on_switch_on():
	_add_spikes()
	if(spikes_off != null):
		spikes_off.hide()


# Called when the element switches from on -> off
func _on_switch_off():
	spikes.queue_free()
	spikes_off.show()


func _add_spikes():
	spikes = spikes_scene.instantiate() as Node2D
	add_child(spikes)
