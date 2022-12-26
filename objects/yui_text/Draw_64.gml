/// @description draw text/scribble element

//if trace {
//	DEBUG_BREAK_YUI;
//}

// draw background
if bg_alpha > 0 {
	draw_sprite_ext(
		yui_white_pixel, 0, 
		x, y, draw_size.w, draw_size.h,
		0, bg_color, bg_alpha * opacity);
}

var color_changed = color_value.update(data_source);
var color = color_value.value ?? c_white;
if highlight && highlight_color != undefined {
	color = highlight_color;
}

if is_string(color) color = yui_resolve_color(color);

if use_scribble {
	scribble_element.blend(color, opacity);

	// draw the scribble element
	scribble_element.draw(x + element_xoffset, y + element_yoffset, typist);
}
else {

	if use_text_surface {
		// TODO: opacity parameters here don't actually work
		// need to make custom shader per Juju
		if viewport_size {
			
			if viewport_part.visible {
				// remake the surface if it doesn't exist
				if !text_surface || !surface_exists(text_surface) {
					buildTextSurface();
				}

				yui_draw_alpha_surface_part(
					text_surface,
					viewport_part.l, viewport_part.t,
					viewport_part.w,// text_surface_w),
					viewport_part.h,// text_surface_h),
					viewport_part.x, viewport_part.y,
					opacity,
					color);
			}
		}
		else {
			// remake the surface if it doesn't exist
			if !text_surface || !surface_exists(text_surface) {
				buildTextSurface();
			}
			if text_surface {
				yui_draw_alpha_surface(text_surface, x, y, opacity, color);
			}
		}
	}
}


if (trace) {
		
	yui_draw_trace_rect(true, padded_rect, yui_padding_color);
	yui_draw_trace_rect(true, draw_rect, yui_draw_rect_color);

	yui_draw_trace_rect(true, draw_size, yui_draw_size_color);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(true, draw_size, yui_hover_color);
	}
	
	if viewport_part {
		yui_draw_trace_rect(true, viewport_part, yui_viewport_color);
	}
	
	if viewport_size {
		yui_draw_trace_rect(true, viewport_size, c_olive);
	}
}