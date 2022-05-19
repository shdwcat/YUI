/// @description calls a YUI event handler, resolving bindings as needed
/// @param handler - the event handler to call
/// @param args - the args to pass to the handler function
/// @param data - the data for any bindings
function yui_call_handler(handler, args, data) {
	
	if handler == undefined {
		yui_warning("Trying to handle undefined event");
		return;
	}
	
	// we might have an array of handlers, which we can resolve sequentially
	if is_array(handler) {
		var i = 0; repeat array_length(handler) {
			yui_call_handler(handler[i++], args, data);
		}
		return;
	}
	
	if variable_struct_exists(handler, "interaction") {
		var did_start = yui_try_start_interaction(handler.interaction, data, handler);
		return did_start;
	}
	else if yui_is_call(handler) {
		// e.g. '@@ some_function(arg1, arg2, etc)'
		handler.resolve(data);
	}
	else if yui_is_lambda(handler) {
		handler.call(data, args);
	}
	else {
		yui_error("unsupported event handler instance");
	}
}