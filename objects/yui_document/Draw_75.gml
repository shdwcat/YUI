/// @description trace

if trace {
	yui_draw_trace_rect(draw_rect, c_blue);
}

if document_error != undefined {
	draw_sprite(yui_error_icon, 0, x, y);
	draw_text_ext(x, y + 69, document_error, -1, 500);
}