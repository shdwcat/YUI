/// @description calls a YUI event handler, resolving bindings as needed
/// @param event - the event to handle
/// @param data - the data for any bindings
/// @param view_item - the view item associated with the data
function yui_handle_event(event, data, view_item = undefined, event_info = undefined) {
	
	if event == undefined {
		yui_warning("Trying to handle undefined event");
		return;
	}
	
	// we might have an array of handlers, which we can resolve sequentially
	if is_array(event) {
		var i = 0; repeat array_length(event) {
			var handler = event[i++];
			yui_handle_event(handler, data, view_item, event_info);
		}
		return;
	}
	
	if yui_is_command(event) {
		// at this point we've resolved the event declaration to the command itself
		var command = event;
		
		// resolve parameter binding if any
		var parameters = yui_resolve_binding(command.parameters_definition, data, view_item);
		
		// if we resolve to something that is not a struct (or undefined), that's an error
		//if parameters != undefined && !is_struct(parameters) {
		//	error("invalid parameter data: parameters");
		//}

		// resolve any bindings in the parameter struct
		if is_struct(parameters) {
			parameters = yui_resolve_struct_bindings(parameters, data, view_item);
		}
		else if is_array(parameters) {
			//TODO
			//parameters = yui_resolve_array_bindings(parameters, data, view_item);
		}
	
		command.execute(parameters, event_info ?? event, view_item);
	}
	else if variable_struct_exists(event, "interaction") {
				
		// TODO: support parameterized interaction?
		// use command pattern?
		
		var did_start = yui_try_start_interaction(event.interaction, data, event);
		return did_start;
	}
	else if yui_is_binding(event) {
		// ideally we should yui_bind and resolve this earlier
		var resolved_event = yui_resolve_binding(event, data);
		
		if resolved_event == undefined {
			yui_warning("could not find event handler from binding");
		}
		else {
			yui_handle_event(resolved_event, data, view_item, event_info);
		}
	}
	else {
		// TODO: fix issue where this can happen when using a $slot binding in an
		// array of handlers (see dropdown_meny.yui item click handler)
		yui_error("unsupported command instance");
	}
}