/// @description draws a trace border if trace is enabled
/// @param props - the props of the renderer to trace
/// @param draw_rect - the rectangle to draw the trace border in
/// @param [trace_color] - the color to draw the trace border
function yui_draw_trace_rect(props, draw_rect) {
	
	if props == true || (is_struct(props) && props.trace) {
		var trace_color = argument_count > 2 ? argument[2] : c_red;	
		draw_rectangle_color(
			draw_rect.x, draw_rect.y, draw_rect.x + draw_rect.w, draw_rect.y + draw_rect.h,
			trace_color, trace_color, trace_color, trace_color, true);
	}
}