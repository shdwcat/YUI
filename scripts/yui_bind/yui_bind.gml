/// @description creates a YuiBinding or YuiMultiBinding if the value is bindable
function yui_bind(value, resources, slot_values) {
	// NOTE: 'value' is the binding_expr
	
	if is_string(value) {
		switch string_char_at(value, 1) {
			case "@":
			case "$":
			case "&":
				return yui_parse_binding_expr(value, resources, slot_values);
			case ">":
				if string_char_at(value, 2) == ">" {
					return yui_parse_binding_expr(value, resources, slot_values);
				}
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
