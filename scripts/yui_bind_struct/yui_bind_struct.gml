/// @description convert any binding expressions on the struct variables to YuiBindings
function yui_bind_struct(struct, resources, slot_values, resolve = false, recursive = false) {
		
	if !is_struct(struct) return; // might be an array? is that useful?
	
	// otherwise bind each key on the struct
	var i = 0; var keys = variable_struct_get_names(struct); repeat array_length(keys) {
		var key = keys[i++];
		var value = struct[$ key];
		
		if recursive && is_struct(value) {
			struct[$ key] = yui_bind_struct(value, resources, slot_values, resolve, true)
		}
		else {
			var result = yui_bind(value, resources, slot_values);
			if resolve && yui_is_binding(result) && !result.is_lambda {
				result = result.resolve();
			}
			struct[$ key] = result;
		}
	}
	
	return struct;
}