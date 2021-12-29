/// @description final trace

if trace {
	yui_draw_trace_rect(trace, draw_size, c_blue);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(trace, draw_size, yui_draw_size_color);
	}
}