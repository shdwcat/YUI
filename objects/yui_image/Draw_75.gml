/// @description final trace

if trace {
	yui_draw_trace_rect(true, draw_size, yui_draw_size_color);
		
	if viewport_part && viewport_part.visible {
		yui_draw_trace_rect(true, viewport_part, yui_viewport_color);
	}

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(true, draw_size, yui_hover_color);
	}
}