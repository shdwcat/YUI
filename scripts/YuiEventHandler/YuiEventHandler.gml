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
			handler.call(data, args, item);
		}
		
		// NOTE: there isn't a clear way to compose the result of each of these into a value to return
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