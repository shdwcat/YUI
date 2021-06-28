/// @description calls a YUI event handler, resolving bindings as needed
/// @param event - the event to handle
/// @param event_source - the renderer that triggered the event (needed to handle stateChange methods)
/// @param ro_context - the render context for the event
/// @param data - the data for any bindings
/// @param [override_parameter] - directly set the handler's parameter from code
function yui_call_event_handler(event, event_source, ro_context, data) {
	
	// we might have an array of handler/param pairs, which we can resolve sequentially
	if is_array(event) {
		var i = 0; repeat array_length(event) {
			var sub_handler = event[i++];
			
			yui_call_event_handler(sub_handler, event_source, ro_context, data)
		}
		return;
	}
	
	if !event return;	
		
	if variable_struct_exists(event, "handler") {	
		
		// resolve the parameters, which can be literals, a binding to an array, or an array of literals/bindings
		var parameters = event[$ "parameters"];
		if !is_undefined(parameters) {
			// resolve parameter binding if any
			parameters = ro_context.resolveBinding(parameters, data);
						
			// convenience: allow a single parameter to be declared without brackets
			if !is_array(parameters) {
				parameters = [parameters];
			}
			// resolve any bindings in the parameter array
			var i = 0; repeat array_length(parameters) {
				parameters[i] = ro_context.resolveBinding(parameters[i], data);
				i++;
			}
		}
		else if argument_count > 4 {
			parameters = [argument[4]];
		}
		else {
			parameters = [];
		}
				
		// the event or handler might be bound to some data on the context
		event = ro_context.resolveBinding(event, data);
		if !event return;
			
		var handler = ro_context.resolveBinding(event.handler, data);
					
		// if the resolved handler is a string, get the script by name
		if is_string(handler) {
			handler = yui_get_script_by_name(handler);
			if !handler {
				yui_error("Error: could not find script with name: " + event.handler);
				return;
			}
		}					
					
		// the handler might be method on an object, where script_execute_ext doesn't work
		var stateChange = noone;
		if is_method(handler) {
			// TODO: remove the target feature entirely because its too complicated
			var target = event[$ "target"];
			
			if target == false {
				stateChange = handler(parameters);
			}
			else {
				if target != undefined {
					target = ro_context.resolveBinding(target, data);
				}
				else {
					target = data;
				}
			
				with (target) {
					// note: no equivalent of script_execute_ext for methods :(
					stateChange = handler(parameters);
				}
			}
		}
		else {
			if is_undefined(parameters) {
				yui_error("Error: cannot pass undefined parameter list to script_execute_ext");
				return;
			}
		
			stateChange = script_execute_ext(handler, parameters);
		}
						
		// if the result of the handler is a stateChange method, call that
		if is_method(stateChange) {
			with event_source {
				var state_key = getStateKey(ro_context, data);
			
				ro_context.applyStateChange(state_key, stateChange, getInitialAnimationState);
			}
		}
	}
	else if variable_struct_exists(event, "interaction") {
		var interaction = YuiCursorManager.interaction_map[$ event.interaction];
		
		// TODO: support parameterized interaction
		
		var did_start = yui_try_start_interaction(interaction, data, event, event_source, ro_context);
		return did_start;
	}
	else {
		yui_log("Error: no handler or interaction declared for event on data:", data);
	}
}