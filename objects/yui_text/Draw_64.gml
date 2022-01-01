/// @description draw scribble element

//if trace {
//	DEBUG_BREAK_YUI;
//}

// draw background
if bg_alpha > 0 {
	draw_rectangle_color(
		x, y, x + draw_size.w, y + draw_size.h,
		bg_color, bg_color, bg_color, bg_color, false);
}

if highlight && highlight_color != undefined {
	scribble_element.blend(highlight_color, 1);
}
else if text_color != c_white {
	scribble_element.blend(text_color, 1);
}

// draw the scribble element
scribble_element.draw(x + element_xoffset, y + element_yoffset, typist);

yui_draw_trace_rect(trace, padded_rect, c_yellow);

yui_draw_trace_rect(trace, draw_size, c_fuchsia);

// debug mouseover trace
if highlight {
	yui_draw_trace_rect(trace, draw_size, c_lime);
}