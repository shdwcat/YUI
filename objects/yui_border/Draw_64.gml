/// @description

// check live bg
// TODO: track hover/focused/etc in a ui_state struct rather than pass the element directly
if background_value.update(data_source, self) || !background_initalized {
	background_initalized = true;

	var bg = background_value.value;
	if is_handle(bg) {
		bg_sprite = bg;
		bg_color = undefined;
		bg_alpha = 1;
	}
	else if bg != undefined {
		bg_sprite = undefined;
		bg_color = is_string(bg)
			? yui_resolve_color(bg)
			: bg;
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