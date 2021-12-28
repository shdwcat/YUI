/// @description if the event value satifies the command pattern returns a YuiCommand, otherwise the event
function yui_resolve_command(event, resources, slot_values) {
	
	if event == undefined return;
	
	// we might have an array of commands, in which case resolve each
	if is_array(event) {
		var i = 0; repeat array_length(event) {
			var command_item = event[i];
			event[i] = yui_resolve_command(command_item, resources, slot_values);
			i++;
		}
		return event;
	}
	
	if is_string(event) {
		return yui_parse_binding_expr(event, resources, slot_values);
	}
	
	var command_id = event[$ "$command"];
	
	// back compat
	if command_id == undefined {
		command_id = event[$ "handler"];
	};
	
	// if it's not a command, we should try to bind it
	if command_id == undefined {
		return yui_bind(event, resources, slot_values);
	}
	
	// if we've got a command id, let's create a YuiCommand
	
	var parameters = event[$ "parameters"];
	yui_bind_struct(parameters, resources, slot_values);
	
	var command = new YuiCommand(command_id, parameters);
	return command;
}