/// @description show warning message with auto conversion of numbers to strings
/// @arg values...
function yui_warning() {

	var message = argument[0];


	var i = 1; repeat argument_count - 1 {
		message += " ";
	
		var token = argument[i]
		if is_string(token)
			message += token;
		else
			message += string(token);
	
		i++;
	}

	show_debug_message(message);

	// TODO: log to warnings.txt


}

function yui_error() {

	var message = argument[0];


	var i = 1; repeat argument_count - 1 {
		message += " ";
	
		var token = argument[i]
		if is_string(token)
			message += token;
		else
			message += string(token);
	
		i++;
	}

	show_debug_message(message);

	// TODO: log to errors.txt
}
