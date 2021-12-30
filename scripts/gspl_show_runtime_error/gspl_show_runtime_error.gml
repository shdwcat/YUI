/// @description prints a runtime error to the log
function gspl_show_runtime_error(error) {
	
	var error_text = "ERROR: " + error.toString() +
		"\n[[line " + string(error.token._line) + "]";
		
	gspl_log(error_text);
	//hadRuntimeError = true;
}