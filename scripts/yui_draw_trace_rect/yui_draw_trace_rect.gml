/// @description draws a trace border
/// @param draw_rect - the rectangle to draw the trace border in
/// @param [trace_color] - the color to draw the trace border
function yui_draw_trace_rect(draw_rect, trace_color = c_red, include_offset = true, coords = false) {
	
	if include_offset {
		draw_rectangle_color(
			draw_rect.x + xoffset,
			draw_rect.y + yoffset,
			draw_rect.x + xoffset + draw_rect.w, 
			draw_rect.y + yoffset + draw_rect.h,
			trace_color, trace_color, trace_color, trace_color, true);
			
		if coords {
			var text = $"x: {floor(draw_rect.x + xoffset)}, y: {floor(draw_rect.y + yoffset)}";
			draw_text(draw_rect.x + xoffset, draw_rect.y + yoffset - 20, text);
			
			var text2 = $"x: {floor(draw_rect.x + xoffset + draw_rect.w)}, y: {floor(draw_rect.y + yoffset + draw_rect.h)}";
			draw_text(
				draw_rect.x + xoffset + draw_rect.w - string_width(text2),
				draw_rect.y + yoffset + draw_rect.h,
				text2);
		}
}
	else {
		draw_rectangle_color(
			draw_rect.x,
			draw_rect.y,
			draw_rect.x + draw_rect.w, 
			draw_rect.y + draw_rect.h,
			trace_color, trace_color, trace_color, trace_color, true);
			
		if coords {
			var text = $"x: {floor(draw_rect.x)}, y: {floor(draw_rect.y)}";
			draw_text(draw_rect.x, draw_rect.y - 20, text);
			
			var text2 = $"x: {floor(draw_rect.x + draw_rect.w)}, y: {floor(draw_rect.y + draw_rect.h)}";
			draw_text(
				draw_rect.x + draw_rect.w - string_width(text2),
				draw_rect.y + draw_rect.h,
				text2);
		}
	}
}

function yui_draw_trace_rect_pos(x, y, w, h, trace_color = c_red) {
	
	draw_rectangle_color(
		x,y, x + w, y + h,
		trace_color, trace_color, trace_color, trace_color, true);
}