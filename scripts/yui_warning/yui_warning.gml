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
	
	static error_count = 0;
	static debug_pointer = undefined;
	static showDebug = function(count) {
		var w = 330;
		var h = 85;
		var _x = window_get_width() - w;
		var _y = window_get_height() - h;
		yui_error.debug_pointer = dbg_view("YUI Errors", true, _x, _y, w, h);
		dbg_text($"{count} errors detected     ");
		dbg_same_line();
		dbg_button("Show Log", function () { show_debug_log(true) }, 80);
		dbg_same_line();
		dbg_button(
			"Clear",
			function () {
				yui_error.error_count = 0;
				dbg_view_delete(yui_error.debug_pointer);
			},
			60);
	}

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
	
	//log_message = message + "\n" + stack;
	
	// show a dbg_view to notify the user of the error and allow them to view the log or clear the count
	showDebug(++error_count);

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


