/// @description

if trace {
	
	yui_draw_trace_rect(draw_rect, yui_draw_rect_color);
	yui_draw_trace_rect(draw_size, yui_draw_size_color);
	
	if highlight {
		yui_draw_trace_rect(draw_size, yui_hover_color);
	}
}