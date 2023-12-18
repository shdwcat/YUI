/// @description here
function yui_validate_number_input(value_str, test_func = real) {
	try {
		var num = test_func(value_str);
		var is_valid = string(num) == value_str;
		
		if is_valid
			return;
		else
			return "Value contains invalid characters";
	}
	catch (error) {
		return yui_get_error_message(error);
	}
}

function yui_get_error_message(error) {
	return instanceof(error) == "YYGMLException"
		? error.message
		: error;
}