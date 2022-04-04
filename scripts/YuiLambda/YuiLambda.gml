/// @description
function YuiLambda(body, context) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	static is_yui_call = true;

	self.body = body;
	self.context = context;
	
	static resolve = function(data) {
		throw yui_error("attemped to resolve() YuiLmabda, use call() instead");
	}
	
	static call = function(data, args) {
		
		// could ditch this scope stuff by passing an 'environment' e.g.
		// foo.resolve(data, environment)
		// might need to be expr_context if we need more than the environment for some reason?
		
		// get the name of the first param
		var param_name = context.arg_map[0];
		
		// set the first arg as the value of the first param
		context.params = {};
		context.params[$ param_name] = args[0];
		
		// call the function body
		body.resolve(data);
		
		// clean up
		context.params = undefined;
	}
}