/// @description 

if trace {

	yui_draw_trace_rect(trace, padded_rect, yui_padding_color);
	//yui_draw_trace_rect(trace, used_layout_size, yui_used_size_color);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(trace, draw_size, yui_draw_size_color);
	}
}
