/// @description creates a YuiBinding or YuiMultiBinding if the value is bindable
function yui_bind(value, resources, slot_values, bind_arrays = false) {
	// NOTE: 'value' is the binding_expr
	
	if yui_is_binding_expr(value) {
		return yui_parse_binding_expr(value, resources, slot_values);
	}
	
	if bind_arrays {
		if is_array(value) {
			return yui_bind_array(value, resources, slot_values);
		}
	}
	
	return value;
}
function yui_bind_and_resolve(value, resources, slot_values) {
	var binding = yui_bind(value, resources, slot_values)
	
	return yui_is_binding(binding)
		? binding.resolve()
		: binding;
}

