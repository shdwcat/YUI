/// @description draws a trace border if trace is enabled
/// @param props - the props of the element to trace
/// @param draw_rect - the rectangle to draw the trace border in
/// @param [trace_color] - the color to draw the trace border
function yui_draw_trace_rect(props, draw_rect, trace_color = c_red) {
	
	if props == true {
		draw_rectangle_color(
			draw_rect.x, draw_rect.y, draw_rect.x + draw_rect.w, draw_rect.y + draw_rect.h,
			trace_color, trace_color, trace_color, trace_color, true);
	}
}