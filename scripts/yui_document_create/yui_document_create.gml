/// @description creates and returns a new yui_document
function yui_document_create(
	yui_file,
	data_context,
	persist = undefined,
	x = 0,
	y = 0,
	depth = 0) {
	
	// we can only pass persist if it's defined, as we can't use undefined,
	// and passing an actual value would override the base value from the yui_document object
	if is_bool(persist) {
		return instance_create_depth(x, y, depth, yui_document, {
			persist,
			yui_file,
			data_context,
		});
	}
	else {
		return instance_create_depth(x, y, depth, yui_document, {
			yui_file,
			data_context,
		});
	}
}