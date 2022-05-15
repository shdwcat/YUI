/// @description draw text/scribble element

//if trace {
//	DEBUG_BREAK_YUI;
//}

// draw background
if bg_alpha > 0 {
	draw_sprite_stretched_ext(
		yui_white_pixel, 0, 
		x, y, draw_size.w, draw_size.h,
		bg_color, bg_alpha * opacity);
}

if use_scribble {
	if highlight && highlight_color != undefined {
		scribble_element.blend(highlight_color, opacity);
	}
	else {	
		scribble_element.blend(text_color, opacity);
	}

	// draw the scribble element
	scribble_element.draw(x + element_xoffset, y + element_yoffset, typist);
}
else {
	var color = text_color ?? c_white;
	if highlight && highlight_color != undefined {
		color = highlight_color;
	}

	if use_text_surface {

		if viewport_size {
			
			if viewport_part.visible
			{		
				// remake the surface if it doesn't exist
				if !text_surface || !surface_exists(text_surface) {
					buildTextSurface();
				}

				yui_draw_alpha_surface_part(
					text_surface,
					viewport_part.l, viewport_part.t,
					viewport_part.w, viewport_part.h,
					viewport_part.x, viewport_part.y);
			}
		}
		else {
			// remake the surface if it doesn't exist
			if !surface_exists(text_surface) {
				buildTextSurface();
			}
			yui_draw_alpha_surface(text_surface, x, y);
		}
	}
}


if (trace) {
	yui_draw_trace_rect(true, padded_rect, yui_padding_color);

	yui_draw_trace_rect(true, draw_size, yui_draw_size_color);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(true, draw_size, yui_hover_color);
	}
	
	if viewport_part {
		yui_draw_trace_rect(true, viewport_part, yui_viewport_color);
	}
}