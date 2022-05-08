/// @description modifies a numeric variable on a target
function yui_modify_numeric_value(target, variable_name, amount) {
	
	if !variable_struct_exists(target, variable_name) {
		throw yui_error("Variable '" + variable_name + "' does not exist on target.");
	}
	
	target[$ variable_name] += amount;
}