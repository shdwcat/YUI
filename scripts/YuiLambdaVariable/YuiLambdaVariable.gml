/// @description resolves the value of a lambda variable from the context
function YuiLambdaVariable(param_name, context) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	static is_yui_call = false;

	self.param_name = param_name;
	self.context = context;
	
	static resolve = function(data) {
		// note: this is some bootleg shit
		return context.params[$ param_name];
	}
}