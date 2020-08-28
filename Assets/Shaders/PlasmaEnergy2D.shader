shader_type canvas_item;

uniform sampler2D plasma_texture;
uniform vec4 plasma_color : hint_color = vec4(1);
uniform float plasma_size : hint_range(0, 2);
uniform float time_scale = 0.1;
uniform float emission_amount;
uniform vec2 sprite_scale = vec2(1.0);

void fragment() {
	vec4 plasma = texture(plasma_texture, UV * sprite_scale);
	plasma = texture(plasma_texture, UV + plasma.rb + TIME * time_scale);
	
	float sample = texture(plasma_texture, UV).r;
	float emission_value = 1.0 - smoothstep(0.0, plasma_size, plasma.r);
	vec3 emission = plasma_color.rgb * emission_value * emission_amount;
	
	COLOR = vec4(
		max(plasma_color.rgb, emission), 
		smoothstep(0.0, plasma_size, plasma.r) * plasma.r);
	//COLOR = plasma;
}