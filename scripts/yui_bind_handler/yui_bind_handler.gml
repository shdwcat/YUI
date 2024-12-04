/// @description binds the provided handler value
function yui_bind_handler(handler, resources, slot_values, fallback_constructor = undefined) {
	
	if handler == undefined return;
	
	// we might have an array of handlers, in which case bind each
	if is_array(handler) {
		var new_handler_array = array_create(array_length(handler));
		var i = 0; repeat array_length(handler) {
			var handler_item = handler[i];
			new_handler_array[i] = yui_bind_handler(handler_item, resources, slot_values, fallback_constructor);
			i++;
		}
		return new YuiArrayEventHandler(new_handler_array);
	}
	
	if is_string(handler) {
		// parse the binding expression and make a handler for it
		var binding = yui_parse_binding_expr(handler, resources, slot_values);
		return new YuiBindingEventHandler(binding);
	}
	else {
		var interaction = handler[$ "interaction"];
		if interaction != undefined {
			return new YuiInteractionEventHandler(handler, resources, slot_values);
		}
		else if fallback_constructor {
			return new fallback_constructor(handler, resources, slot_values);
		}
		else {
			throw yui_error($"Unexpected event handler content of type {instanceof(handler)}");
		}
	}
}