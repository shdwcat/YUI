/// @description Formats a series of values into a string
function yui_string_concat() {

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

	return message;


}
