function YuiBindingEventHandler(yui_expr) constructor {
	expr = yui_expr;
	
	static call = function(data, args) {
		if expr.is_lambda {
			expr.call(data, args);
		}
		else {
			expr.resolve(data);
		}
	}
}

function YuiArrayEventHandler(handler_array) constructor {
	self.handler_array = handler_array;
	
	static call = function(data, args, item) {
		var i = 0; repeat array_length(handler_array) {
			handler = handler_array[i++];
			var result = handler.call(data, args, item);
		}
		
		// returns the result of the last handler in the array
		return result;
	}
}

function YuiInteractionEventHandler(props, resources, slot_values) constructor {
	
	static default_props = {
		interaction: undefined,
		parameters: {},
	}
	
	interaction = props.interaction;
	parameters = undefined;
	
	if variable_struct_exists(props, "parameters") {
		parameters = yui_bind_struct(props.parameters, resources, slot_values, , true)
	}
	
	static call = function(data, args, item) {
		var did_start = yui_try_start_interaction(interaction, data, self, item);
		return did_start;
	}
}