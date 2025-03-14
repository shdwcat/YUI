/// @description draw final trace

event_inherited();

if trace {

	yui_draw_trace_rect(padded_rect, yui_padding_color);
	
	if used_layout_size
		yui_draw_trace_rect(used_layout_size, yui_used_size_color);

	// debug mouseover trace
	if highlight {
		yui_draw_trace_rect(draw_size, yui_hover_color);
	}
}