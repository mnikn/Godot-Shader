shader_type canvas_item;

uniform int pattern : hint_range(0, 2) = 0; // diamond, circle, square
uniform float shake_speed: hint_range(1.0, 100.0) = 10.0;
uniform float shake_size: hint_range(0.0, 5.0) = 0.2;
uniform float shake_move_speed: hint_range(1.0, 100.0) = 15.0;
uniform vec2 shake_move_direction = vec2(0.8, 0.9);
uniform vec2 shake_move_size = vec2(0.2, 0.2);

void vertex() {
	float time = TIME * shake_move_speed;
	VERTEX.x += cos(time * shake_move_direction.x + UV.x) * shake_move_size.x;
	VERTEX.y += sin(time * shake_move_direction.y + UV.y) * shake_move_size.y;
}

bool hasContraryNeighbour(float width, vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset;
		
		if (pattern == 0) {
			offset = width - abs(x);
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		} else if (pattern == 2) {
			offset = width;
		}
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a == 0.0) == false) {
				return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	vec2 uv = UV;
	float width = 0.0;
	float time = TIME * shake_speed;
	
	if (step(abs(cos(time + UV.y + UV.x)), 0.5) == 1.0) {
		width += shake_size;
	}
	
	COLOR = texture(TEXTURE, uv);
	
	if (hasContraryNeighbour(width, uv, TEXTURE_PIXEL_SIZE, TEXTURE) ) {
		COLOR.rgb = COLOR.rgb;
		COLOR.a += (1.0 - COLOR.a);
	}
}