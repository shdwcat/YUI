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

	if text_surface {

		// remake the surface if it doesn't exist
		if !surface_exists(text_surface) {
			buildTextSurface();
		}

		if viewport_size {
			
			//yui_draw_alpha_surface(text_surface, x, y);
			
			var trim = trimToViewport(x, y, text_surface_w, draw_size.h);
			
			var yrel = y - parent.y;
			var yoffset = y - viewport_size.y;
			if yoffset < 0 {
				DEBUG_BREAK_YUI;
			}
			
			yui_draw_alpha_surface_part(
				text_surface,
				x < viewport_size.x ? viewport_size.vx : 0,
				yoffset < 0 ? viewport_size.vy - yrel : 0,
				trim.w, trim.h,
				trim.x, trim.y);
			//draw_rectangle_color(
			//	trim.x, trim.y, trim.x2, trim.y2,
			//	c_blue, c_blue, c_blue, c_blue, true);
		}
		else {
			yui_draw_alpha_surface(text_surface, x, y);
		}
	}
}


if (trace) {
	yui_draw_trace_rect(trace, padded_rect, c_yellow);

	yui_draw_trace_rect(trace, draw_size, c_fuchsia);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(trace, draw_size, c_lime);
	}
}