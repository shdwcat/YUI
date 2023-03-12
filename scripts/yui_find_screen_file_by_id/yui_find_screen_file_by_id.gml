/// @description
function yui_find_screen_file_by_id(screen_id) {
	
	var cabinet_file = YuiGlobals.screens[$ screen_id];
	
	if cabinet_file {
		var path = cabinet_file.fullpath;
		
		if YUI_LIVE_RELOAD_ENABLED {
			path = yui_string_after(path, YUI_LOCAL_PROJECT_DATA_FOLDER);
		}
		
		return path;
	}
}