// TODO: need to combine this with yui_init_props and fix the edge cases

/// @description fills in any missing fields in the provided props with values from default_props
function init_props_old(_props) {
	if is_undefined(_props) {
		_props = {};
	}
	
	// loop through the values in default_props and add them to _props if missing
	var keys = variable_struct_get_names(default_props);
	var i = 0; repeat array_length(keys) {
		var key = keys[i++];
		var exists = variable_struct_exists(_props, key);
		if !exists {
			var default_value = variable_struct_get(default_props, key);
			variable_struct_set(_props, key, default_value);
		}
	}
	
	return _props;
}