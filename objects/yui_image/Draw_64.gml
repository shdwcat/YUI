/// @description 

// maybe just draw_self()?
// currently we only need the custom call for blend_color (and ignoring sprite origin)

// todo: 9-slicing?

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
				viewport_part.x + sprite_xoffset,
				viewport_part.y + sprite_yoffset,
				image_xscale, image_yscale,
				image_angle,
				blend_color, blend_color, blend_color, blend_color,
				image_alpha);
		}
	}
	else {
		draw_sprite_ext(
			sprite_index, image_index,
			x + sprite_xoffset,
			y + sprite_yoffset,
			image_xscale, image_yscale,
			image_angle, blend_color, image_alpha);
	}
}