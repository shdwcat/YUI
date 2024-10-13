/// @description resolves the value of a lambda variable from the context
function YuiLambdaVariable(param_name, context) : YuiExpr() constructor {
	static is_yui_live_binding = true;

	self.param_name = param_name;
	self.context = context;
	
	static resolve = function(data) {
		// gets the defined parameter from the 'context params' which in this case
		// is set up in YuiLambda/YuiLambdaParselet
		// note: this is some bootleg shit
		return context.params[$ param_name];
	}

	static compile = function()
	{
		return param_name;
	}
}