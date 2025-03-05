/// @description
function YuiThenElseBinding(left, then_expr, else_expr) : YuiExpr() constructor {
	static is_yui_live_binding = true; // check inner bindings?
	
	self.left = left;
	self.then_expr = then_expr;
	self.else_expr = else_expr;
	
	// we're callable if either then and else are callable
	self.is_call = then_expr.is_call || else_expr.is_call
	
	if !left.is_yui_live_binding
		&& !then_expr.is_yui_live_binding
		&& (else_expr == undefined or !else_expr.is_yui_live_binding) {
		self.is_yui_live_binding = false;
	}
	
	static debug = function() {
		return {
			_type: instanceof(self),
			condition: left.debug(),
			then_expr: then_expr.debug(),
			else_expr: else_expr.debug(),
			is_call,
		}
	}
	
	static resolve = function(data)
	{
		var left_val = left.resolve(data);
		
		if left_val {
			return then_expr.resolve(data);
		}
		else if else_expr {
			return else_expr.resolve(data);
		}
	}
	
	static optimize = function() {
		if is_yui_live_binding && !left.is_yui_live_binding {
			if left.resolve() == true
				return then_expr
			else
				return else_expr
		}
		return self;
	}
	
	static compile = function() {
		return left.compile() + " ? " + then_expr.compile() + " : " + else_expr.compile();
	}
} 