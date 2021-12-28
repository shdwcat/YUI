/// @description
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