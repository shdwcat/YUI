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
		// need to support calling an array directly until widgets have dedicated
		// `events` that get bound as handlrs, with proper merging for inheriting widgets
		var i = 0; repeat array_length(handler) {
			var handler_item = handler[i++];
			
			if is_instanceof(handler_item, YuiExpr) && !handler_item.is_call {
				handler_item.resolve(data);
			}
			else {
				handler_item.call(data, args, self);
			}
		}
	}
	else {
		return handler.call(data, args, self);
	}
}