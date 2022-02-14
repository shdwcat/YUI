/// @description

// draw background
if bg_alpha > 0 {
	
	if bg_sprite != undefined {
		// use 9slicing
		draw_sprite_stretched_ext(
			bg_sprite, 0,
			draw_size.x, draw_size.y, draw_size.w, draw_size.h,
			c_white, bg_alpha * opacity);
	}
	else if bg_color != undefined {
		draw_sprite_stretched_ext(
			yui_white_pixel, 0,
			draw_size.x, draw_size.y, draw_size.w, draw_size.h,
			bg_color, bg_alpha * opacity);
	}
}

// draw border
if border_color != undefined &&	border_thickness > 0 && border_alpha > 0 {	
	var prev_alpha = draw_get_alpha();
	draw_set_alpha(border_alpha * opacity);
	yui_draw_rect_outline(
		draw_size.x, draw_size.y, draw_size.w, draw_size.h,
		border_thickness, border_color);
	draw_set_alpha(prev_alpha);
}