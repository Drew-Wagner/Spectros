@tool
extends Toggleable

@onready var spider_body: Area2D = $SpiderBody

@export var move_speed: float = 256 # pixels / sec
@export var move_in_editor: bool = false
var move_direction: Vector2 = Vector2.DOWN

func _draw():
	if spider_body == null:
		return

	draw_line(32 * Vector2.UP, spider_body.position, Color.WHITE_SMOKE, 4, true)

func _process(delta):
	queue_redraw()
	super(delta)

func _on_switch_on():
	move_direction = Vector2.DOWN

func _on_switch_off():
	move_direction = Vector2.UP

func _physics_process(delta):
	super(delta)
	if not Engine.is_editor_hint() or move_in_editor:
		if spider_body.position.length() <= delta * move_speed:
			is_on = true

		if move_direction == Vector2.DOWN or not %RayCast2D.is_colliding():
			spider_body.position += delta * move_speed * move_direction


func _on_area_2d_body_entered(body):
	if body.has_method("kill"):
		body.kill()
	else:
		if move_direction == Vector2.DOWN:
			is_on = false
