/// @description trace

yui_draw_trace_rect(trace, draw_rect, c_blue);

if document_error != undefined {
	draw_sprite(yui_error_icon, 0, x, y);
	var element = scribble(document_error)
		.wrap(500)
		.draw(x, y + 69);
}