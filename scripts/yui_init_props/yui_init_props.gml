// TODO: replace uses of this with yui_apply_props
/// @description fills in any missing fields in the provided props with values from default_props
/// @param _props		- the props to fill in
/// @param [base_props]	- the base props for this struct
function yui_init_props(_props, _default_props = undefined) {
	var is_base = _default_props != undefined;
	_default_props ??= default_props;
	
	if is_undefined(_props) {
		_props = {};
	}
	
	// loop through the values in _default_props and add them to _props if missing
	var keys = variable_struct_get_names(_default_props);
	var i = 0; repeat array_length(keys) {
		var key = keys[i++];
		var exists = variable_struct_exists(_props, key);
		if !exists {
			var default_value = variable_struct_get(_default_props, key);
			variable_struct_set(_props, key, default_value);
		}
	}
	
	if !is_base && variable_struct_exists(self, "base_props") {
		// loop through the values in base_props and add them to _props if missing
		var keys = variable_struct_get_names(base_props);
		var i = 0; repeat array_length(keys) {
			var key = keys[i++];
			var exists = variable_struct_exists(_props, key);
			if !exists {
				var default_value = variable_struct_get(base_props, key);
				variable_struct_set(_props, key, default_value);
			}
		}
	}
	
	return _props;
}

/// @description applies layers of props-definitions to a struct instance
/// @param instance_data  - the props for this instance
/// @param [props_layer1,...] - additional props to be applied to the instance data
function yui_apply_props(instance_data) {
	
	// special casing for just instance_data, see if we have default_props and/or base_props
	if argument_count == 1 {
		var _default_props = variable_struct_get(self, "default_props");
		var _base_props = variable_struct_get(self, "base_props");
		
		if _base_props && _default_props {
			return yui_apply_props(instance_data, _default_props, _base_props);
		}
		else if _base_props {
			return yui_apply_props(instance_data, _base_props);
		}
	}
			
	// set up a new struct to hold the result to avoid modifying the raw instance_data
	var result = {};
	
	var j = 0; repeat argument_count {
		var source = argument[j++];
		
		// if no instance_data is provided skip it, we'll just apply the props layers
		if j == 1 && source == undefined continue;
	
		// loop through the values in the source and add them to the result if missing
		var keys = variable_struct_get_names(source);
		var i = 0; repeat array_length(keys) {
			var key = keys[i++];
			var exists = variable_struct_exists(result, key);
			if !exists {
				var source_value = source[$ key];
				result[$ key] =  source_value;
			}
		}
	}
	
	return result;
}