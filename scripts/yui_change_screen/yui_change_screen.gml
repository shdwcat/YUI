/// @description changes the screen file for the current document and reloads it
function yui_change_screen(screen_id, view_item) {
	
	var root = view_item.parent;
	while root.parent != undefined {
		root = root.parent;
	}
	
	root_document = root.document;
	
	var screen_file = yui_find_screen_file_by_id(screen_id);
	
	if screen_file == undefined {
		throw yui_error("unable to find screen for id: " + screen_id);
	}
	
	// change the file path, then reload
	root_document.yui_file = screen_file;
	root_document.reload();
}