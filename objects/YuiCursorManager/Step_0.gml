/// @description check overlay GUI hotspots

// get mouse position once per frame
cursor_state_gui = {
	x: device_mouse_x_to_gui(device_index),
	y: device_mouse_y_to_gui(device_index),
};

cursor_state = {
	x: mouse_x,
	y: mouse_y,
};