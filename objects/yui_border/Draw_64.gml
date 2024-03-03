/// @description

// check live bg - TODO: move to process() override to keep code organized?
if is_bg_sprite_live {
	bg_sprite_value.update(data_source);
	if bg_sprite_value.value != undefined {
		bg_sprite = bg_sprite_value.value;
		bg_alpha = 1;
	}
}
else if is_bg_color_live {
	bg_color_value.update(data_source);
	if bg_color_value.value != undefined {
		bg_color = bg_color_value.value;
		if is_string(bg_color)
			bg_color = yui_resolve_color(bg_color);
		bg_alpha = ((bg_color & 0xFF000000) >> 24) / 255; // extract alpha
	}
}

// draw background
if bg_alpha > 0 {
	
	if bg_sprite != undefined {
		// use 9slicing
		draw_sprite_stretched_ext(
			bg_sprite, 0,
			x, y, draw_size.w, draw_size.h,
			c_white, bg_alpha * opacity);
	}
	else if bg_color != undefined {
		if viewport_size {
			if viewport_part.visible {
				if viewport_part.clipped {
					draw_sprite_ext(
						yui_white_pixel, 0,
						viewport_part.x, viewport_part.y, viewport_part.w, viewport_part.h,
						0, bg_color, bg_alpha * opacity);
				}
				else {
					draw_sprite_ext(
						yui_white_pixel, 0,
						x, y, draw_size.w, draw_size.h,
						0, bg_color, bg_alpha * opacity);
				}
			}
		}
		else {
			draw_sprite_ext(
				yui_white_pixel, 0,
				x, y, draw_size.w, draw_size.h,
				0, bg_color, bg_alpha * opacity);
		}
	}
}

// draw border
if draw_border {
	var do_draw = false;
	
	if focused && has_focus_color {
		var do_draw = true;
		var color = border_focus_color;
		var alpha = 1;
	}
	else if !focused && has_border_color {
		var do_draw = true;
		var color = border_color;
		var alpha = border_alpha;
	}
	
	if do_draw {
		if viewport_size {
			if viewport_part.visible {
				if viewport_part.clipped {
					yui_draw_rect_outline_clipped(
						x, y, draw_size.w, draw_size.h,
						viewport_part.x, viewport_part.y, viewport_part.x2, viewport_part.y2,
						border_thickness, color, alpha * opacity);
				}
				else {
					yui_draw_rect_outline(
						x, y, draw_size.w, draw_size.h,
						border_thickness, color, alpha * opacity);
				}
			}
		}
		else {
			yui_draw_rect_outline(
				x, y, draw_size.w, draw_size.h,
				border_thickness, color, alpha * opacity);
		}
	}
}