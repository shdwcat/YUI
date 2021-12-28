/// @description
function gspl_get_runtime_function_map() {
	var result = {};
	
	var i = 0;
	var function_name = script_get_name(i);
	
	do {
		result[$ function_name] = i;
		i++;
		function_name = script_get_name(i);
	}
	until function_name == "<unknown>";
		
	return result;
}