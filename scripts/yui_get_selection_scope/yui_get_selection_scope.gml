/// @description gets a selection scope by id, if it exists
function yui_get_selection_scope(scope_id) {
	if ds_map_exists(YuiGlobals.selection_scopes, scope_id) {
		var scope = YuiGlobals.selection_scopes[? scope_id];
		return scope;
	}
}