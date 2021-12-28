/// @description modifies a numeric variable on a target
function yui_modify_numeric_value(target, variable_name, amount) {
	target[$ variable_name] += amount;	
}