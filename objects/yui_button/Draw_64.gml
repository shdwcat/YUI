/// @description draw alpha + highlight

var show_highlight = (highlight || focused)
	&& highlight_color != undefined
	&& enabled;
	
if show_highlight and trace
	mx_break()
	
active_bg_blend_color = show_highlight
	? highlight_color
	: (enabled
		? bg_blend_color
		: c_white);

// Inherit the parent event
event_inherited();

// draw the highlight color as an overlay when either there is no background sprite, or there is
// and the highlight color is white (because white won't do anything as active_bg_blend_color
var draw_highlight = show_highlight and (bg_sprite == undefined or highlight_color & $ffffff);
if draw_highlight {
	
	var alpha = (button_pressed ? pressed_alpha : highlight_alpha) * opacity;
	if alpha > 0 {
		if viewport_size {
			if viewport_part.visible {
				if viewport_part.clipped {
					draw_sprite_ext(
						yui_white_pixel, 0,
						viewport_part.x + xoffset, viewport_part.y + yoffset, viewport_part.w, viewport_part.h,
						0, highlight_color, alpha);
				}
				else {
					draw_sprite_ext(
						yui_white_pixel, 0,
						x, y, draw_size.w, draw_size.h,
						0, highlight_color, alpha);
				}
			}
		}
		else {
			draw_sprite_ext(
				yui_white_pixel, 0,
				x, y, draw_size.w, draw_size.h,
				0, highlight_color, alpha);
		}
	}
}

//if content_item {
//	// can solve this in the cursor manager hover logic
//  // except that doesn't handle hovering over the button but not the context (due to padding)
//	content_item.highlight = highlight;
//}

