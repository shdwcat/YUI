/// @description trace

if (trace) {
		
	yui_draw_trace_rect(padded_rect, yui_padding_color);
	//yui_draw_trace_rect(draw_rect, yui_draw_rect_color);
	
	if viewport_part {
		yui_draw_trace_rect(viewport_part, yui_viewport_color);
	}

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(draw_size, yui_hover_color);
	}
}