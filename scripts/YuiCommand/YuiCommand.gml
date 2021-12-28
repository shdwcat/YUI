/// @description Command class for commands declared in the .yui file like:
///     $command: script_name
///     parameters: { name: value }
function YuiCommand(_command_id, _parameters_definition) constructor {
	command_id = _command_id;
	
	if _parameters_definition == undefined {
		parameters_definition = {};
	}
	else {
		parameters_definition = _parameters_definition;
	}

	execute_handler = yui_get_script_by_name(command_id); // TODO: pull from whitelist map
	
	if !execute_handler {
		yui_error("Error: could not find script with name:", command_id);
		return;
	}
	// TODO: undo_handler
	
	static execute = function(params, event_info, view_item) {
		
		// back compat for scripts taking params directly
		if is_array(params) {
			return script_execute_ext(execute_handler, params);
		}
		else if !is_struct(params) {
			return script_execute_ext(execute_handler, [params]);
		}
		
		return execute_handler(params, event_info, view_item);
	}
}



// Do I even need this class?