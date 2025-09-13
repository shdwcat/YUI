/// @description creates a YuiExpr if the value is bindable
function yui_bind(expr_value, resources, slot_values, bind_arrays = false) {
	
	var value = YUI.Parser.parse(expr_value, resources, slot_values);
	
	if bind_arrays and is_array(value) {
		return yui_bind_array(value, resources, slot_values);
	}
	
	return value;
}

function yui_bind_and_resolve(value, resources, slot_values, data = undefined) {
	var binding = yui_bind(value, resources, slot_values)
	
	return yui_is_binding(binding)
		? binding.resolve(data)
		: binding;
}

