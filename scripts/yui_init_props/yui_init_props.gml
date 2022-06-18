// TODO next major version - delete this

/// @description fills in any missing fields in the provided props with values from default_props
/// @param _props		- the props to fill in
/// @param [base_props]	- the base props for this struct
//function yui_init_props(_props, _default_props = undefined) {
//	var is_base = _default_props != undefined;
	
//	if !is_base {
//		if (default_props != undefined) {
//			_default_props = default_props;
//		}
//	}
	
//	if is_undefined(_props) {
//		_props = {};
//	}
	
//	// loop through the values in _default_props and add them to _props if missing	
//	var keys = variable_struct_get_names(_default_props);
//	var i = 0; repeat array_length(keys) {
//		var key = keys[i++];
//		var exists = variable_struct_exists(_props, key);
//		if !exists {
//			var default_value = variable_struct_get(_default_props, key);
//			variable_struct_set(_props, key, default_value);
//		}
//	}
	
//	if !is_base && variable_struct_exists(self, "base_props") {
//		// loop through the values in base_props and add them to _props if missing
//		var keys = variable_struct_get_names(base_props);
//		var i = 0; repeat array_length(keys) {
//			var key = keys[i++];
//			var exists = variable_struct_exists(_props, key);
//			if !exists {
//				var default_value = variable_struct_get(base_props, key);
//				variable_struct_set(_props, key, default_value);
//			}
//		}
//	}
	
//	return _props;
//}
