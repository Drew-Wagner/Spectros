@tool
extends Node2D

signal stopped()
signal at_top()
signal at_bottom()
signal start_ascend()
signal start_descend()

var move_direction: Vector2 = Vector2.UP
var is_at_top: bool = false
var is_at_bottom: bool = false


func ascend():
	is_at_bottom = false
	move_direction = Vector2.UP
	start_ascend.emit()


func descend():
	is_at_top = false
	move_direction = Vector2.DOWN
	start_descend.emit()


func stop():
	move_direction = Vector2.ZERO
	stopped.emit()

@onready var descend_timer: Timer = $DescendTimer
@onready var ascend_timer: Timer = $AscendTimer
@onready var spider_body: CharacterBody2D = $SpiderBody

@export var move_speed: float = 256 # pixels / sec
@export var move_in_editor: bool = false

func _disconnect_descend_timer():
	descend_timer.stop()
	if descend_timer.timeout.is_connected(descend):
		descend_timer.timeout.disconnect(descend)
	if at_top.is_connected(descend_timer.start):
		at_top.disconnect(descend_timer.start)


func _disconnect_ascend_timer():
	ascend_timer.stop()
	if ascend_timer.timeout.is_connected(ascend):
		ascend_timer.timeout.disconnect(ascend)
	if at_bottom.is_connected(ascend_timer.start):
		at_bottom.disconnect(ascend_timer.start)


func _bypass_descend_timer():
	_disconnect_descend_timer()
	if not at_top.is_connected(descend):
		at_top.connect(descend)

func _bypass_ascend_timer():
	_disconnect_ascend_timer()
	if not at_bottom.is_connected(ascend):
		at_bottom.connect(ascend)

func _disconnect_descend_bypass():
	if at_top.is_connected(descend):
		at_top.disconnect(descend)

func _disconnect_ascend_bypass():
	if at_bottom.is_connected(ascend):
		at_bottom.disconnect(ascend)

func _connect_descend_timer():
	descend_timer.wait_time = descend_wait_time
	if not descend_timer.timeout.is_connected(descend):
		descend_timer.timeout.connect(descend)
	if not at_top.is_connected(descend_timer.start):
		at_top.connect(descend_timer.start)

func _connect_ascend_timer():
	ascend_timer.wait_time = ascend_wait_time
	if not ascend_timer.timeout.is_connected(ascend):
		ascend_timer.timeout.connect(ascend)
	if not at_bottom.is_connected(ascend_timer.start):
		at_bottom.connect(ascend_timer.start)

func _configure_descend_timer():
	if descend_wait_time > 0:
		_connect_descend_timer()
	elif descend_wait_time == 0:
		_bypass_descend_timer()
	else:
		_disconnect_descend_timer()
		_disconnect_descend_bypass()

func _configure_ascend_timer():
	if ascend_wait_time > 0:
		_connect_ascend_timer()
	elif ascend_wait_time == 0:
		_bypass_ascend_timer()
	else:
		_disconnect_ascend_timer()
		_disconnect_ascend_bypass()


@export var descend_wait_time: float:
	set(value):
		descend_wait_time = value
		
		if descend_timer != null:
			_configure_descend_timer()


@export var ascend_wait_time: float:
	set(value):
		ascend_wait_time = value
		
		if ascend_timer != null:
			_configure_ascend_timer()


func _ready():
	_configure_ascend_timer()
	_configure_descend_timer()

func _process(_delta):
	queue_redraw()


func _physics_process(_delta):
	if Engine.is_editor_hint() and not move_in_editor:
		return
	
	spider_body.velocity = move_speed * move_direction
	spider_body.move_and_slide()
	
	if spider_body.is_on_floor() and not is_at_bottom:
		stop()
		is_at_bottom = true
		at_bottom.emit()
	elif spider_body.is_on_ceiling() and not is_at_top:
		stop()
		is_at_top = true
		at_top.emit()


func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		body.kill()


# Draws the "spider web" line.
func _draw():
	if spider_body == null:
		return

	draw_line(32 * Vector2.UP, spider_body.position, Color.WHITE_SMOKE, 4, true)
