/// @description
function YuiThenElseBinding(left, then_expr, else_expr) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true; // check inner bindings?
	
	self.left = left;
	self.then_expr = then_expr;
	self.else_expr = else_expr;
	
	if (!left.is_yui_live_binding
		&& !then_expr.is_yui_live_binding
		&& !else_expr.is_yui_live_binding) {
		self.is_yui_live_binding = false;
	}
	
	static resolve = function(data)
	{
		var left_val = left.resolve(data);
		
		if left_val {
			return then_expr.resolve(data);
		}
		else {
			return else_expr.resolve(data);
		}
	}
	
	
} 