/// @description 

// todo: 9-slicing?

image_alpha = opacity ?? draw_get_alpha();

if frame_value.is_live frame_value.update(data_source);
var frame = frame_value.value;
if frame != undefined {
	image_index = frame_value.value;
	image_speed = 0;
}

if angle_value.is_live angle_value.update(data_source);
image_angle = angle_value.value;

if blend_color_value.is_live blend_color_value.update(data_source);
var color = blend_color_value.value;
if is_string(color) color = yui_resolve_color(color);

if sprite_index >= 0 {
	if viewport_size {
		if viewport_part.visible
		{
			// TODO clipping logic is ignoring scale/angle
			// probably need a shader to solve that!
			draw_sprite_general(
				sprite_index, image_index,
				viewport_part.l / image_xscale,
				viewport_part.t / image_yscale,
				viewport_part.w / image_xscale,
				viewport_part.h / image_yscale,
				viewport_part.x,
				viewport_part.y,
				image_xscale, image_yscale,
				image_angle,
				color, color, color, color,
				image_alpha);
		}
	}
	else {
		draw_sprite_ext(
			sprite_index, image_index,
			x + sprite_xoffset,
			y + sprite_yoffset,
			image_xscale, image_yscale,
			image_angle, color, image_alpha);
	}
}