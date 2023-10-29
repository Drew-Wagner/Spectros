@tool
class_name Platform
extends AnimatableBody2D

func next_waypoint():
	target = waypoints[(waypoints.find(target) + 1) % len(waypoints)]

@onready var sprite2D = $Sprite2D
@onready var collisionShape2D = $CollisionShape2D

@export var speed: float = 64
@export var is_autonomous: bool = true:
	set (value):
		if value:
			is_toggleable = false
		is_autonomous = value
@export var is_toggleable: bool = false:
	set (value):
		if value:
			is_autonomous = false
		is_toggleable = value
@export var width: int = 1:
	set(value):
		width = max(0, value)
		_set_sprite2d_region()
		_set_collision_shape_size()
@export var height: int = 1:
	set(value):
		height = max(0, value)
		_set_sprite2d_region()
		_set_collision_shape_size()

@export var waypoints: Array[Vector2] = [position]:
	set(value):
		if !value:
			value = [position]
		waypoints = value
@export var texture: Texture2D:
	set(value):
		texture = value
		_set_sprite2d_region()
@export var top_texture: Texture2D = null
@export var right_texture: Texture2D = null
@export var bottom_texture: Texture2D = null
@export var left_texture: Texture2D = null

var target: Vector2

var width_pixels: int:
	get:
		return texture.get_width() * width if texture else 0
var height_pixels: int:
	get:
		return texture.get_height() * height if texture else 0

var _waypoint_hint_font: SystemFont
			
func _ready():
	collisionShape2D.shape = RectangleShape2D.new()
	_set_collision_shape_size()
	if Engine.is_editor_hint():
		_waypoint_hint_font = SystemFont.new()
		_waypoint_hint_font.font_names = ["monospace"]
	else:
		for i in len(waypoints):
			waypoints[i] += position
			
	if is_toggleable:
		OnOff.toggle.connect(next_waypoint)
	
	target = waypoints[0]

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
		
func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	var vector_to_target = (target - position)
	var velocity = vector_to_target.normalized() * speed
	var displacement = velocity * delta
	
	constant_linear_velocity = velocity
	
	if vector_to_target.length() < (speed * delta):
		position = target
		if is_autonomous: # go to next waypoint
			next_waypoint()
	else:
		position += displacement

func _draw():
	if Engine.is_editor_hint():
		var packed_waypoints = PackedVector2Array(waypoints)
		packed_waypoints.append(waypoints[0])

		var r = 16
		var color = collisionShape2D.debug_color
		
		draw_polyline(packed_waypoints, color, 2)
		for i in len(waypoints):
			var point = waypoints[i]
			
			draw_circle(point, r, color)
			draw_string(_waypoint_hint_font, 0.3*r*Vector2.LEFT + 0.25*r*Vector2.DOWN + point, str(i), HORIZONTAL_ALIGNMENT_CENTER, -1, r)
	
	var canvas_transform = get_canvas_transform()
	if top_texture:
		draw_texture_rect(
			top_texture,
			Rect2(-width_pixels / 2, -height_pixels / 2 - top_texture.get_height(),
				  width_pixels, top_texture.get_height()), true)
	if bottom_texture:
		draw_set_transform_matrix(canvas_transform.rotated(PI))
		draw_texture_rect(
			bottom_texture,
			Rect2(-width_pixels / 2, -height_pixels / 2 - bottom_texture.get_height(),
				  width_pixels, bottom_texture.get_height()), true)
	if right_texture:
		draw_set_transform_matrix(canvas_transform.rotated(PI / 2))
		draw_texture_rect(
			right_texture,
			Rect2(-height_pixels / 2, -width_pixels / 2 - right_texture.get_height(),
				  height_pixels, right_texture.get_height()), true)
	if left_texture:
		draw_set_transform_matrix(canvas_transform.rotated(3 * PI / 2))
		draw_texture_rect(
			left_texture,
			Rect2(-height_pixels / 2, -width_pixels / 2 - left_texture.get_height(),
				  height_pixels, left_texture.get_height()), true)



func _set_sprite2d_region():
	if !sprite2D:
		Callable(_set_sprite2d_region).call_deferred()
		return

	sprite2D.texture = texture
	sprite2D.region_rect = Rect2i(
		0,
		0,
		width_pixels,
		height_pixels)

func _set_collision_shape_size():
	if !collisionShape2D:
		Callable(_set_collision_shape_size).call_deferred()
		return
	
	collisionShape2D.shape.set_size(Vector2(width_pixels, height_pixels))
