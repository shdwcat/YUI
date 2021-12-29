/// @description

// draw background
if bg_alpha > 0 {
	if bg_sprite != undefined {
		// use 9slicing
		draw_sprite_stretched(bg_sprite, 0, draw_size.x, draw_size.y, draw_size.w, draw_size.h);
	}
	else if bg_color != undefined {			
		draw_rectangle_color(
			draw_size.x, draw_size.y,
			draw_size.x + draw_size.w - 1,
			draw_size.y + draw_size.h - 1,
			bg_color, bg_color, bg_color, bg_color, false);
	}
}

// draw border
if border_color != undefined &&	border_thickness > 0 && border_alpha > 0 {				
	yui_draw_rect_outline(
		draw_size.x, draw_size.y, draw_size.w, draw_size.h,
		border_thickness, border_color);
}