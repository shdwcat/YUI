/// @description binds the provided handler value
function yui_bind_handler(handler, resources, slot_values) {
	
	if handler == undefined return;
	
	// we might have an array of handlers, in which case resolve each
	if is_array(handler) {
		var new_handler_array = array_create(array_length(handler));
		var i = 0; repeat array_length(handler) {
			var handler_item = handler[i];
			new_handler_array[i] = yui_bind_handler(handler_item, resources, slot_values);
			i++;
		}
		return new_handler_array;
	}
	
	if is_string(handler) {
		return yui_parse_binding_expr(handler, resources, slot_values);
	}
	else {
		// should only be for interactions
		// TODO: error if it's not an interaction
		
		var interaction = handler[$ "interaction"];
		if interaction != undefined && variable_struct_exists(handler, "parameters") {
			
			// return a new struct to avoid modifying source data
			return {
				interaction: interaction,
				parameters: yui_bind_struct(handler.parameters, resources, slot_values, , true),
			};
		}
		
		return yui_bind(handler, resources, slot_values);
	}
}