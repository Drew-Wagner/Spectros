@tool
extends Toggleable

@onready var spider_body: Area2D = $SpiderBody

@export var descent_delay: float = 0 # seconds
@export var ascent_delay: float = 0 # seconds
@export var move_speed: float = 256 # pixels / sec
@export var move_in_editor: bool = false
var move_direction: Vector2 = Vector2.UP

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
		if move_direction == Vector2.UP and spider_body.position.length() <= delta * move_speed:
			move_direction = Vector2.ZERO
			await get_tree().create_timer(descent_delay).timeout
			move_direction = Vector2.DOWN

		if not (move_direction == Vector2.UP and %RayCast2D.is_colliding()):
			spider_body.position += delta * move_speed * move_direction


func _on_area_2d_body_entered(body):
	if body.has_method("kill"):
		body.kill()

	if move_direction == Vector2.DOWN:
		move_direction = Vector2.ZERO
		await get_tree().create_timer(ascent_delay).timeout
		move_direction = Vector2.UP
