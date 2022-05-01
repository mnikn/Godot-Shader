shader_type canvas_item;

uniform vec2 wind_power = vec2(1.0, 0.0);
uniform float speed = 3.0;

void fragment() {
	vec2 pixel_size = vec2(wind_power.x / float(textureSize(TEXTURE, 0).x), wind_power.y / float(textureSize(TEXTURE, 0).y));
	vec4 sprite_color = texture(TEXTURE, UV);
	
	float time = TIME * speed;
	float v = sin(time);
	COLOR = texture(TEXTURE, UV + vec2(pixel_size.x, pixel_size.y) * v);
}