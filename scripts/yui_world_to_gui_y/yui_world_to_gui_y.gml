/// @description convert world y to gui y
function yui_world_to_gui_y(y, view = 0) {
	var camera_y = camera_get_view_y(view_camera[view]);
	var camera_h = camera_get_view_height(view_camera[view]);
	
	var yoffset = y - camera_y;

	// convert to gui
	var yoffset_percent = yoffset / camera_h;

	var gui_y = yoffset_percent * display_get_gui_height();

	return floor(gui_y);
}

// this should replace the above but needs more testing with existing cursor behavior
/// @param {Real} y
/// @param {Id.Camera,Real} camera
function yui_world_to_gui_y_2(y, camera = 0) {
	if view_enabled {
		var camera_y = camera_get_view_y(view_camera[camera]);
		var camera_h = camera_get_view_height(view_camera[camera]);
		var viewport_h = view_hport[camera];
		var window_h = window_get_height();

		// position relative to camera
		var yoffset = y - camera_y;

		// find the relation of the camera y to the camera size
		var camera_ratio_y = yoffset / camera_h;

		// multiple by the viewport size to get the x position in the view
		var y_in_viewport = camera_ratio_y * viewport_h;
		
		var view_scale_h = viewport_h / window_h;
		var y_in_window = y_in_viewport / view_scale_h;
		
		// account for the viewport's y
		y_in_window += view_get_yport(camera);
			
		return floor(y_in_window);
	}
	else {
		// when views are not enabled, the full room is drawn scaled to the window size
		var window_h = window_get_height();

		// find the relation of the room y to the room height
		var room_ratio_y = y / room_height;
		var y_in_window = room_ratio_y * window_h;

		return floor(y_in_window);
	}
}