/// @description prints a runtime error to the log
function show_runtime_error(error) {
	
	var error_text = "ERROR: " + error.toString() +
		"\n[[line " + string(error.token._line) + "]";
		
	debug_log(error_text);
	//hadRuntimeError = true;
}