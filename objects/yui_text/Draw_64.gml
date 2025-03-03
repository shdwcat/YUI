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

var color_changed = color_value.is_live && color_value.update(data_source);
var color = color_value.value ?? c_white;
if highlight && highlight_color != undefined {
	color = highlight_color;
}

if is_string(color) color = yui_resolve_color(color);

if use_scribble {	
	if regions.enabled {
		var hover_region = scribble_element.region_detect(
			x + element_xoffset,
			y + element_yoffset,
			device_mouse_x_to_gui(0),
			device_mouse_y_to_gui(0));
			
		var region_changed = hover_region != active_region;
		if region_changed {
			active_region = hover_region;
			
			if regions.highlight {
				if active_region == undefined {
					scribble_element.region_set_active(undefined);
				}
				else {
					scribble_element.region_set_active(active_region, regions.color, regions.blend);
				}
			}
			
			if events.on_region_hover_changed != undefined {
				var element = self;
				var args = {
					source: element,
					scribble_element: scribble_element,
					region: active_region,
				};
		
				yui_call_handler(events.on_region_hover_changed, [args], data_source);
			}
		}
	}
	
	if viewport_size {
		if viewport_part.visible {
			var scissor = gpu_get_scissor();
			gpu_set_scissor(viewport_part);
			
			// draw the scribble element
			scribble_element.blend(color, opacity);
			scribble_element.draw(x + element_xoffset, y + element_yoffset, typist);
			
			gpu_set_scissor(scissor);
		}
	}
	else {
		// draw the scribble element
		scribble_element.blend(color, opacity);
		scribble_element.draw(x + element_xoffset, y + element_yoffset, typist);
	}
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
			if text_surface == undefined || !surface_exists(text_surface) {
				buildTextSurface();
			}
			if text_surface != undefined {
				yui_draw_alpha_surface(text_surface, x + element_xoffset, y + element_yoffset, opacity, color);
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