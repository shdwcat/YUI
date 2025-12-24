function YuiEventHandlerBase() constructor {
	// for YUI, 'source' is the element that is performing the call
	static call = function (data, args,	source) {
		throw yui_error($"{instanceof(self)} does not implement call()");
	}
}

function YuiBindingEventHandler(yui_expr) : YuiEventHandlerBase() constructor {
	expr = yui_expr;
	
	static call = function(data, args, source) {
		if expr.is_lambda {
			expr.call(data, args, source);
		}
		else {
			expr.resolve(data);
		}
	}
}

function YuiArrayEventHandler(handler_array) : YuiEventHandlerBase() constructor {
	self.handler_array = handler_array;
	
	static call = function(data, args, source) {
		var result = undefined;
		
		var i = 0; repeat array_length(handler_array) {
			handler = handler_array[i++];
			result = handler.call(data, args, source);
		}
		
		// returns the result of the last handler in the array
		return result;
	}
}

function YuiInteractionEventHandler(props, resources, slot_values) : YuiEventHandlerBase() constructor {
	
	static default_props = {
		interaction: undefined,
		parameters: {},
	}
	
	interaction = props.interaction;
	parameters = undefined;
	
	if variable_struct_exists(props, "parameters") {
		parameters = yui_bind_struct(props.parameters, resources, slot_values, , true)
	}
	
	static call = function(data, args, source) {
		var did_start = yui_try_start_interaction(interaction, data, self, source);
		return did_start;
	}
}