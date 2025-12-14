/// @description
function YuiLambda(body, context) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	static is_call = true;
	static is_lambda = true;

	self.body = body;
	self.context = context;
	self.compiled_script_name = undefined;
	
	static debug = function() {
		return {
			_type: instanceof(self),
			body: body.debug(),
		}
	}
	
	static resolve = function(data) {
		// return a closure bound to the data_context where the lambda was declared
		return new YuiClosure(self, data);
	}
	
	static call = function(data, args) {
		
		// could ditch this scope stuff by passing an 'environment' e.g.
		// foo.resolve(data, environment)
		// might need to be expr_context if we need more than the environment for some reason?
		
		// TODO: currently nested lambdas will only have access to the inner lambda params
		// would to use e.g. YuiChainedMap to be able to inherit params values inside
		
		// set the context params from the args array
		context.params = {};
		
		if is_array(args) {
			var i = 0; repeat array_length(args) {
				var param_name = context.arg_map[i];
				context.params[$ param_name] = args[i];
				i++;
			}
		}
		else {
			var param_name = context.arg_map[0];
			context.params[$ param_name] = args;
		}
		
		// call the function body
		var result = body.resolve(data);
		
		// clean up
		context.params = undefined;
		
		return result;
	}

	static compile = function(func_name = "")
	{
		return "function " + func_name + "(data, " + context.arg_map[0] + ") {\n\t" + body.compile() + "\n}\n\n";
	}
}

function YuiClosure(lambda_expr, original_data_context) : YuiExpr() constructor {
	static is_yui_live_binding = true;
	static is_call = true;
	static is_lambda = true;
	
	self.lambda_expr = lambda_expr;
	
	// this is the data context from where the lambda was defined
	self.original_data_context = original_data_context;
	
	static call = function(data, args) {
		
		// call the lambda with the data context from when the lambda was resolved
		return lambda_expr.call(original_data_context, args);
	}
}