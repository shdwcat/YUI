/// @description convert world x to gui x
function yui_world_to_gui_x(x, view = 0) {
	var camera_x = camera_get_view_x(view_camera[view]);
       
    var xoffset = x - camera_x;
       
    // convert to gui
    var xoffset_percent = xoffset / camera_get_view_width(view_camera[view]);
       
    var gui_x = xoffset_percent * display_get_gui_width();
	
	return gui_x;
}