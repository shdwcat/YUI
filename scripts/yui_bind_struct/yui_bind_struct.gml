/// @description convert any binding expressions on the struct variables to YuiBindings
function yui_bind_struct(struct, resources, slot_values, resolve = false, recursive = false) {
		
	if !is_struct(struct)
		return struct; // might be an array? is that useful?
	
	// return a new struct to avoid modifying source data
	var bound_struct = {};
	
	// otherwise bind each key on the struct
	var i = 0; var keys = variable_struct_get_names(struct); repeat array_length(keys) {
		var key = keys[i++];
		var value = struct[$ key];
		
		if recursive {
			if is_struct(value) && !yui_is_binding(value) {
				bound_struct[$ key] = yui_bind_struct(value, resources, slot_values, resolve, true)
				continue;
			}
			if is_array(value) {
				bound_struct[$ key] = yui_bind_array(value, resources, slot_values, resolve, true)
				continue;
			}
		}
		
		var result = yui_bind(value, resources, slot_values);
		if resolve && yui_is_binding(result) && !result.is_lambda {
			result = result.resolve();
		}
		bound_struct[$ key] = result;
	}
	
	return bound_struct;
}