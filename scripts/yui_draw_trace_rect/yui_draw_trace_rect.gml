/// @description draws a trace border
/// @param draw_rect - the rectangle to draw the trace border in
/// @param [trace_color] - the color to draw the trace border
function yui_draw_trace_rect(draw_rect, trace_color = c_red) {
	
	draw_rectangle_color(
		draw_rect.x + xoffset,
		draw_rect.y + yoffset,
		draw_rect.x + xoffset + draw_rect.w, 
		draw_rect.y + yoffset + draw_rect.h,
		trace_color, trace_color, trace_color, trace_color, true);
}

function yui_draw_trace_rect_pos(x, y, w, h, trace_color = c_red) {
	
	draw_rectangle_color(
		x,y, x + w, y + h,
		trace_color, trace_color, trace_color, trace_color, true);
}