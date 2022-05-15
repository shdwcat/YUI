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
		if viewport_size {
			if viewport_part.visible {
				draw_sprite_ext(
					yui_white_pixel, 0,
					viewport_part.x, viewport_part.y, viewport_part.w, viewport_part.h,
					0, bg_color, bg_alpha * opacity);
			}
		}
		else {
			draw_sprite_ext(
				yui_white_pixel, 0,
				draw_size.x, draw_size.y, draw_size.w, draw_size.h,
				0, bg_color, bg_alpha * opacity);
		}
	}
}

// draw border
if border_color != undefined &&	border_thickness > 0 && border_alpha > 0 {	
	if viewport_size {
		if viewport_part.visible {
			if viewport_part.clipped {
				yui_draw_rect_outline_clipped(
					draw_size.x, draw_size.y, draw_size.w, draw_size.h,
					viewport_part.x, viewport_part.y, viewport_part.x2, viewport_part.y2,
					border_thickness, border_color, border_alpha * opacity);
			}
			else {
				yui_draw_rect_outline(
					draw_size.x, draw_size.y, draw_size.w, draw_size.h,
					border_thickness, border_color, border_alpha * opacity);
			}
		}
	}
	else {
		yui_draw_rect_outline(
			draw_size.x, draw_size.y, draw_size.w, draw_size.h,
			border_thickness, border_color, border_alpha * opacity);
	}
}