/// @description convert any binding expressions on the struct variables to YuiBindings
function yui_bind_struct(struct, resources, slot_values, resolve = false, recursive = false) {
	
	if !is_struct(struct)
		return struct; // might be an array? is that useful?
	
	// return a new struct to avoid modifying source data
	var bound_struct = {};
	
	var data_type = undefined;
		
	// otherwise bind each key on the struct
	var i = 0; var keys = variable_struct_get_names(struct); repeat array_length(keys) {
		var key = keys[i++];
		var value = struct[$ key];
		
		if recursive {
			if is_struct(value) && !yui_is_binding(value) {
				var key_struct = yui_bind_struct(value, resources, slot_values, resolve, true);
				
				// merge data type from inner struct
				if struct_exists(key_struct, "__data_type")
					data_type = mx_merge_data_types(data_type, key_struct.__data_type);
				
				bound_struct[$ key] = key_struct;
				continue;
			}
			if is_array(value) {
				bound_struct[$ key] = yui_bind_array(value, resources, slot_values, resolve, true);
				
				// NOTE: we can't track the array data type unless we shift to passing the data type
				// to the binding functions (though that might be cleaner than .__data_type)
				
				continue;
			}
		}
		
		var result = yui_bind(value, resources, slot_values);
		
		if yui_is_binding(result) {
			data_type = mx_merge_data_types(data_type, result.data_type);
			
			if resolve
				result = result.resolve();
		}
		
		bound_struct[$ key] = result;
	}
		
	// store the data type on the struct
	bound_struct.__data_type = data_type;
	
	return bound_struct;
}