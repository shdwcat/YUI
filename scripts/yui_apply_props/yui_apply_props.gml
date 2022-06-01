/// @description applies layers of props-definitions to a struct instance/// @param instance_data  - the props for this instance
/// @param [props_layer1,...] - additional props to be applied to the instance data
function yui_apply_props(instance_data) {
	
	// special casing for just instance_data, see if we have default_props and/or base_props
	if argument_count == 1 {
		var _default_props = variable_struct_get(self, "default_props");
		var _base_props = variable_struct_get(self, "base_props");
		
		return yui_apply_props(instance_data, _default_props, _base_props);
	}
			
	// set up a new struct to hold the result to avoid modifying the raw instance_data
	var result = {};
	
	var j = 0; repeat argument_count {
		var source = argument[j++];
		
		// if any layer is undefined, just skip it
		if source == undefined continue;
	
		// loop through the values in the source and add them to the result if missing
		var keys = variable_struct_get_names(source);
		var i = 0; repeat array_length(keys) {
			var key = keys[i++];
			
			if key == "focusable" && instanceof(self) == "YuiButtonElement"
				DEBUG_BREAK_YUI
			
			var exists = variable_struct_exists(result, key);
			if !exists {
				var source_value = source[$ key];
				result[$ key] =  source_value;
			}
		}
	}
	
	return result;
}

function yui_apply_element_props(instance_data) {
	return yui_apply_props(instance_data, element_theme, default_props, base_props);
}

