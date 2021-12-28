/// @description
function YuiThenElseBinding(left, then_expr, else_expr) constructor {
	static is_yui_binding = true;
	
	self.left = left;
	self.then_expr = then_expr;
	self.else_expr = else_expr;
	
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