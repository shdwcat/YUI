/// @description calls a YUI event handler
/// @param handler - the event handler to call
/// @param args - the args to pass to the handler function (only used by lambdas)
/// @param data - the data for any bindings
function yui_call_handler(handler, args, data) {
	
	if handler == undefined {
		yui_warning("Trying to call undefined event handler");
		return;
	}
	else if is_array(handler) {
		// meed to support calling an array directly until widgets have dedicated
		// `events` support with proper merging for inherited widgets
		var i = 0; repeat array_length(handler) {
			var handler_item = handler[i++];
			handler_item.call(data, args, self);
		}
	}
	else {
		return handler.call(data, args, self);
	}
}