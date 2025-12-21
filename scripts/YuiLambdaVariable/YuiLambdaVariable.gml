/// @description resolves the value of a lambda variable from the context
function YuiLambdaVariable(param_name, context) : YuiExpr() constructor {
	static is_yui_live_binding = true;

	self.param_name = param_name;
	self.context = context;
	
	static debug = function() {
		return {
			_type: instanceof(self),
			param_name,
		}
	}
	
	static resolve = function(data) {
		// gets the defined parameter from the 'context params' which in this case
		// is set up in YuiLambda/YuiLambdaParselet
		
		// debug assert
		if !context.isParamIdentifier(param_name)
			throw dcs_error($"Could not get lambda param value for: '{param_name}'");
			
		return context.getParamValue(param_name);
	}

	static compile = function()
	{
		return param_name;
	}
}