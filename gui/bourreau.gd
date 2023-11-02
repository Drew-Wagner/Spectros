extends TextureRect

@onready var animation: AnimationPlayer = $AnimationPlayer

func on_toggle_switched_on():
	animation.play("switch")

func on_toggle_switched_off():
	animation.play_backwards("switch")
