// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function yui_load_screen(screen_id, data_context) {	
	// find yui file by id
	var file = yui_find_screen_file_by_id(screen_id);	
	
	// pass the screen file to load via global variable
	global.__yui_pending_screen_file = file;
	global.__yui_pending_screen_context = data_context;
	room_goto(YuiScreenRoom);
}

// TODO move this?
function yui_find_screen_file_by_id(screen_id) {	
	var hits = gumshoe(YUI_DATA_SUBFOLDER, ".yui", false);
	var i = 0; repeat array_length(hits) {
		var path = hits[i++];
		
		// stil a hack
		var tokens = yui_string_split(path, "\\");
		var filename = tokens[array_length(tokens) - 1];
		
		if filename == screen_id + ".yui" {
			return path;	
		}
	}
}