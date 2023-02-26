/// @description draw final trace

//if trace {
//	DEBUG_BREAK;
//}

//if padded_rect.h < 0 exit;

if trace {

	yui_draw_trace_rect(trace, padded_rect, yui_padding_color);
	
	if used_layout_size
		yui_draw_trace_rect(trace, used_layout_size, yui_used_size_color);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(trace, draw_size, yui_hover_color);
	}
}