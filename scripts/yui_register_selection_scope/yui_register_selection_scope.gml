#macro register_selection_scope yui_register_selection_scope

/// @description Registers a selection scope if it does not already exist
function yui_register_selection_scope(scope_id, scope_config) {
	if ds_map_exists(YuiGlobals.selection_scopes, scope_id) {
		var scope = YuiGlobals.selection_scopes[? scope_id];
		return scope;
	}
	else {
		var scope = new SelectionScope(scope_id, scope_config);
		YuiGlobals.selection_scopes[? scope_id] = scope;
		return scope;
	}
}