/// @description changes the screen file for the current document and reloads it
function yui_change_screen(screen_id, view_item) {
	
	var root_document = view_item.parent;
	while root_document.parent != undefined {
		root_document = root_document.parent;
	}
	
	var screen_file = yui_find_screen_file_by_id(screen_id);
	
	// change the file path, then reload
	root_document.yui_file = screen_file;
	root_document.reload();
}