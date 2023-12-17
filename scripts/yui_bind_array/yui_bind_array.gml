/// @description convert any binding expressions on the array values variables to YuiBindings
function yui_bind_array(array, resources, slot_values, resolve = false, recursive = false) {
	
	var bound_array = array_create(array_length(array));
	
	var i = 0; repeat array_length(array) {
		var value = array[i];
		
		if recursive && is_struct(value) {
			bound_array[i] = yui_bind_struct(value, resources, slot_values, resolve, true)
		}
		else if recursive && is_array(value) {
			bound_array[i] = yui_bind_array(value, resources, slot_values, resolve, true)
		}
		else {
			var result = yui_bind(value, resources, slot_values);
			if resolve && yui_is_binding(result) && !result.is_lambda {
				result = result.resolve();
			}
			bound_array[i] = result;
		}
		
		i++;
	}
	
	return bound_array;
}