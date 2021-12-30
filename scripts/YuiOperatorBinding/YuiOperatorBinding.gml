/// @description
function YuiOperatorBinding(left, operator, right) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.left = left;
	self.right = right;
	self.operator = operator;
	
	static resolve = function(data)
	{
		var left_val = yui_resolve_binding(left, data);
		
		switch operator {
			// NOTE: order is roughly in expected frequency
			case YS_TOKEN.EQUAL_EQUAL:
			case YS_TOKEN.EQUALS:
				// TODO: per type logic here (arrays, structs, ?)
				return left_val == yui_resolve_binding(right, data);
				
			case YS_TOKEN.BANG_EQUAL:
				return left_val != yui_resolve_binding(right, data);
				
			case YS_TOKEN.AND:
				return left_val && yui_resolve_binding(right, data);
				
			case YS_TOKEN.OR:
				return left_val || yui_resolve_binding(right, data);
				
			case YS_TOKEN.PLUS:
				return left_val + yui_resolve_binding(right, data);
				
			case YS_TOKEN.MINUS:
				return left_val - yui_resolve_binding(right, data);
				
			case YS_TOKEN.STAR:
				return left_val * yui_resolve_binding(right, data);
				
			case YS_TOKEN.SLASH:
				return left_val / yui_resolve_binding(right, data);
				
			case YS_TOKEN.GREATER:
				return left_val > yui_resolve_binding(right, data);
				
			case YS_TOKEN.GREATER_EQUAL:
				return left_val >= yui_resolve_binding(right, data);
				
			case YS_TOKEN.LESS:
				return left_val < yui_resolve_binding(right, data);
				
			case YS_TOKEN.LESS_EQUAL:
				return left_val <= yui_resolve_binding(right, data);
		}
	}
	
	
} 