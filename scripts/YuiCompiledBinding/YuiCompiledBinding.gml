function YuiCompiledBinding(script_id, source, expr) : YuiExpr() constructor {
	static is_yui_binding = true;
	self.is_yui_live_binding = expr.is_live;
	
	self.resolve = script_id;
	self.source = source;
	self.type = expr.type;
	self.is_call = expr.is_call;
	self.is_lambda = expr.is_lambda;
	
	static call = function(data, args) {
		// TODO support multiple args
		resolve(data, args[0]);
	}

	static checkType = function() { return type; }
}
