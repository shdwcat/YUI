/// @description 

is_mouse_over = YuiCursorManager.isMouseOver();

// maybe just draw_self()?
// currently we only need the custom call for blend_color (and ignoring sprite origin)

// todo: 9-slicing?

if sprite_index >= 0 {
	draw_sprite_ext(
		sprite_index, image_index,
		x + sprite_xoffset,
		y + sprite_yoffset,
		image_xscale, image_yscale,
		image_angle, blend_color, image_alpha);
}