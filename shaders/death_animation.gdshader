shader_type canvas_item;

uniform float speed = 5;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb += 0.75;
	COLOR.a *= ((cos(speed * TIME) + 1.0) / 4.0) + 0.5;
}
