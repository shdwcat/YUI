/// @description changes the screen file for the current document and reloads it
function yui_change_screen(screen_id, view_item) {
	
	// find the screen file by the id
	var screen_file = yui_find_screen_file_by_id(screen_id);	
	if screen_file == undefined {
		throw yui_error("unable to find screen for id: " + screen_id);
	}
	
	// get the document
	
	var is_doc = view_item[$"object_index"] == yui_document;
	if is_doc {
		var document = view_item;
	}
	else {
		var document = view_item.document;
	}
	
	// change the file path, then reload
	document.yui_file = screen_file;
	document.reload();
}