@tool
extends ToggleMovingPlatform

@export_enum("Up", "Right", "Down", "Left") var orientation: int:
	set(value):
		orientation = value
		_set_orientation()

@export_enum("Brick", "Wood") var material_texture: int:
	set(value):
		material_texture = value
		_set_material()

@export var sprite: Sprite2D
@export var brick_texture: Texture2D
@export var wood_texture: Texture2D

var active_border: Sprite2D

enum Orientation {
	Up,
	Right,
	Down,
	Left
}

enum MaterialTexture {
	Brick,
	Wood
}

func _draw():
	if Engine.is_editor_hint():	
		var label = Label.new()
		label.text = "⬆️"
		draw_string(label.get_theme_font(""), 32 * Vector2.LEFT + 10 * Vector2.DOWN, "⬆️", HORIZONTAL_ALIGNMENT_CENTER, 64, 32)

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _set_orientation():
	match orientation:
		Orientation.Up:
			set_border($%BorderUp)
			rotation = 0
		
		Orientation.Right:
			set_border($%BorderRight)
			rotation = deg_to_rad(90)
		
		Orientation.Down:
			set_border($%BorderDown)
			rotation = deg_to_rad(180)
		
		Orientation.Left:
			set_border($%BorderLeft)
			rotation = deg_to_rad(-90)


func _set_material():
	if sprite == null:
		return

	match material_texture:
		MaterialTexture.Brick:
			sprite.set_texture(brick_texture)
		
		MaterialTexture.Wood:
			sprite.set_texture(wood_texture)
	
	_set_orientation()


func set_border(border: Sprite2D):
	if active_border != null:
		active_border.hide()
	else:
		$%BorderUp.hide()
	
	if MaterialTexture.Wood == material_texture or border == null:
		return
	
	border.show()
	active_border = border
