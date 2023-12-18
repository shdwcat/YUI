/// @description final trace

// debug mouseover trace
if trace {
	
	yui_draw_trace_rect(true, draw_rect, yui_draw_rect_color);
	yui_draw_trace_rect(true, draw_size, yui_draw_size_color);
	
	if viewport_part && viewport_part.visible {
		yui_draw_trace_rect(true, viewport_part, yui_viewport_color);
	}
	
	if highlight {
		yui_draw_trace_rect(true, draw_size, yui_hover_color);
	}
}