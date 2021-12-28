/// @description convert any binding expressions on the struct variables to YuiBindings
function yui_bind_struct(struct, resources, slot_values) {
		
	if !is_struct(struct) return; // might be an array? is that useful?
	
	// otherwise bind each key on the struct
	var i = 0; var keys = variable_struct_get_names(struct); repeat array_length(keys) {
		var key = keys[i++];
		var value = struct[$ key];
		struct[$ key] = yui_bind(value, resources, slot_values)
	}
	
	return struct;
}