gml_pragma("force_inline");


function yui_mouse_in_rect(rect) {
	// todo support other device indexes?
	
	return point_in_rectangle(
		device_mouse_x_to_gui(0),
		device_mouse_y_to_gui(0),
		rect.x, rect.y, rect.x + rect.w, rect.y + rect.h);
}

function yui_cursor_in_rect(cursor_pos, rect) {
	return point_in_rectangle(
		cursor_pos.x,
		cursor_pos.y,
		rect.x, rect.y, rect.x + rect.w, rect.y + rect.h);
}