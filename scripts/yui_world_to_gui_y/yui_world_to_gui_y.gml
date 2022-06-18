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