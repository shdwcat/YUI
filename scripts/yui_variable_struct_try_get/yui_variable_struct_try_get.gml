/// @description gets the named value from the struct if it exists, or 'undefined' if not
function yui_variable_struct_try_get(struct, name, default_value = undefined) {
	if variable_struct_exists(struct, name) {
		return variable_struct_get(struct, name);
	}
	else {
		return default_value;
	}
}

