/// @description changes the screen file for the current document and reloads it
function yui_change_screen(params, event_info, view_item) {
	
	var root_document = view_item.parent;
	while root_document.parent != undefined {
		root_document = root_document.parent;
	}
	
	var screen_file = yui_find_screen_file_by_id(params.screen);
	
	// change the file path and data context, then reload
	root_document.yui_file = screen_file;
	if params[$ "data_context"] {
		root_document.data_context = params.data_context;
	}
	
	root_document.reload();
}