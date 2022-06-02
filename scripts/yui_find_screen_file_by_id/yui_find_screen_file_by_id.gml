/// @description
function yui_find_screen_file_by_id(screen_id) {
	
	var cabinet_file = YuiGlobals.screens[$ screen_id];
	
	if cabinet_file {
		return cabinet_file.fullpath;
	}
}