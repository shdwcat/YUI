/// @description log to debug window
function debug_log() {
	var args = array_create(argument_count);
	var i = 0; repeat argument_count {
		args[i] = argument[i];
		i++;
	}
	
	var message = script_execute_ext(string_concat, args);
	show_debug_message(message);
	
	debug.debug_output += string(message) + "\n";	
}