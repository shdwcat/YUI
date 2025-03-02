/// @description convert world x to gui x
function yui_world_to_gui_x(x, view = 0) {
	var camera_x = camera_get_view_x(view_camera[view]);
	var camera_w = camera_get_view_width(view_camera[view]);

	var xoffset = x - camera_x;

	// convert to gui
	var xoffset_percent = xoffset / camera_w;

	var gui_x = xoffset_percent * display_get_gui_width();
	
	return floor(gui_x);
}

// this should replace the above but needs more testing with existing cursor behavior
/// @param {Real} x
/// @param {Id.Camera,Real} camera
function yui_world_to_gui_x_2(x, camera = 0) {
		
	if view_enabled {
		var camera_x = camera_get_view_x(view_camera[camera]);
		var camera_w = camera_get_view_width(view_camera[camera]);
		var viewport_w = view_wport[camera];
		var window_w = window_get_width();

		// position relative to camera
		var xoffset = x - camera_x;

		// find the relation of the camera x to the camera size
		var camera_ratio_x = xoffset / camera_w;
			
		// multiply by the viewport size to get the x position in the view
		var x_in_viewport = camera_ratio_x * viewport_w;
		
		var view_scale_w = viewport_w / window_w;
		var x_in_window = x_in_viewport / view_scale_w;
		
		// account for the viewport's x
		x_in_window += view_get_xport(camera);

		return floor(x_in_window);
	}
	else {
		// when views are not enabled, the full room is drawn scaled to the window size
		var window_w = window_get_width();

		// find the relation of the room x to the room width
		var room_ratio_x = x / room_width;
		var x_in_window = room_ratio_x * window_w;

		return floor(x_in_window);
	}
}