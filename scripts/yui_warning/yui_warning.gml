/// @description show warning message with auto conversion of numbers to strings
/// @arg values...
function yui_warning() {

	var message = "YUI WARNING: " + string(argument[0]);


	var i = 1; repeat argument_count - 1 {
		message += " ";
	
		var token = argument[i]
		if is_string(token)
			message += token;
		else
			message += string(token);
	
		i++;
	}

	// TODO: log to errors.txt
	show_debug_message(message);
	return message;
}

function yui_error() {

	var message = "YUI ERROR: " + string(argument[0]);


	var i = 1; repeat argument_count - 1 {
		message += " ";
	
		var token = argument[i]
		if is_string(token)
			message += token;
		else
			message += string(token);
	
		i++;
	}
	
	var stack = string_join_ext("\n", debug_get_callstack(12));
	
	log_message = message + "\n" + stack;

	// TODO: log to errors.txt
	show_debug_message(message);
	return {
		message: message,
		stacktrace: stack,
		toString: function() {
			return string("{0}\nSTACK:\n{1}", message, stacktrace);
		}
	};
}


