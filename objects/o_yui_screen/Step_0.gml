/// @description update elements

if draw_to_gui {
	var cursor_state = { x: device_mouse_x_to_gui(device), y: device_mouse_y_to_gui(device) };
}
else {
	var cursor_state = { x: mouse_x, y: mouse_y };
}

// only run update if we're on the frame cadence
if --frame_count <= 0 {
	yui_document.update(data_context, draw_region, cursor_state);
	
	frame_count = frame_cadence;	
}

// handle cursor events
yui_document.handleHotspots(cursor_state, YuiCursorManager.cursor_event);