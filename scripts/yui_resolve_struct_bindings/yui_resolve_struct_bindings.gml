/// @description resolves any bindings in the variables of the struct (not recursive)
function yui_resolve_struct_bindings(struct, data, view_item) {
	if !is_struct(struct) return struct;
	
	var resolved = {};
	var i = 0; var keys = variable_struct_get_names(struct); repeat array_length(keys) {
		var key = keys[i++];
		var value = struct[$ key];
		resolved[$ key] = yui_resolve_binding(value, data, view_item);
	}
	
	return resolved;
}