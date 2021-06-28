/// @description gets a selection scope by id, if it exists
function yui_get_selection_scope(scope_id) {
	if ds_map_exists(ui_state.selection_scopes, scope_id) {
		var scope = ui_state.selection_scopes[? scope_id];
		return scope;
	}
}