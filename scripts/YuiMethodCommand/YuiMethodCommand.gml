/// @description Command class for commands created from methods
function YuiMethodCommand(method, _parameters_definition = undefined, _scope = undefined) constructor {
		
	if _parameters_definition == undefined {
		parameters_definition = {};
	}
	else {
		parameters_definition = _parameters_definition;
	}
	
	scope = _scope;

	execute_handler = method
	// TODO: undo_handler
	
	static execute = function(params, event_info) {	
		
		// if we have a scope, call the handler in that scope
		if scope != undefined {
			var handler = execute_handler;
			with (scope) {
				return handler(params, event_info);
			}
		}
		
		return execute_handler(params, event_info);
				
	}
}