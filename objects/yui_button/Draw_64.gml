/// @description draw alpha + highlight

if !bound_values.enabled {
	var alpha = draw_get_alpha();
	draw_set_alpha(0.5);
}

// Inherit the parent event
event_inherited();

if !bound_values.enabled {
	draw_set_alpha(alpha);
}

var show_highlight = (highlight || YuiCursorManager.focused_item == id)
	&& highlight_color != undefined
	&& bound_values.enabled;
	
if show_highlight {
	var alpha = button_pressed ? pressed_alpha : highlight_alpha;
	if alpha > 0 {
		if viewport_size {
			if viewport_part.visible {
				if viewport_part.clipped {
					draw_sprite_ext(
						yui_white_pixel, 0,
						viewport_part.x, viewport_part.y, viewport_part.w, viewport_part.h,
						0, highlight_color, alpha);
				}
				else {
					draw_sprite_ext(
						yui_white_pixel, 0,
						draw_size.x, draw_size.y, draw_size.w, draw_size.h,
						0, highlight_color, alpha);
				}
			}
		}
		else {
			draw_sprite_ext(
				yui_white_pixel, 0,
				draw_size.x, draw_size.y, draw_size.w, draw_size.h,
				0, highlight_color, alpha);
		}
	}
}

//if content_item {
//	// can solve this in the cursor manager hover logic
//  // except that doesn't handle hovering over the button but not the context (due to padding)
//	content_item.highlight = highlight;
//}

