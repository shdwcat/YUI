/// @description sets the selected item on a selection scope
function yui_selection_scope_select_item(params, event_info) {
	if params.scope {
		var item = event_info.data;
		//var item = params.item;
		params.scope.select(item);
	}
	else {
		yui_error("no selection scope!");
	}
}