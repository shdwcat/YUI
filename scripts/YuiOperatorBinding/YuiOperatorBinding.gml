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
		
		// NOTE: could set resolve specific to operator to avoid the switch at bind time
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
				
			default:
				throw gspl_log("Unknown operator: " + operator.getTokenName());
		}
	}
		
} 

/// @description
function YuiPrefixOperatorBinding(operator, right) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;

	self.operator = operator;
	self.right = right;
	
	static resolve = function(data)
	{
		var right_val = yui_resolve_binding(right, data);
		
		// NOTE: could set resolve specific to operator to avoid the switch at bind time
		switch operator {
			// NOTE: order is roughly in expected frequency
			case YS_TOKEN.NOT:
				return !right_val;
				
			default:
				throw gspl_log("Unknown operator: " + operator.getTokenName());
		}
	}
}