/// @description
function YuiOperatorBinding(left, operator, right) constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.left = left;
	self.right = right;
	self.operator = operator._type;
	self.operator_name = operator.getTokenName();
	
	if (!left.is_yui_live_binding && !right.is_yui_live_binding) {
		self.is_yui_live_binding = false;
	}
	
	static resolve = function(data)
	{
		var left_val = left.resolve(data);
		
		// NOTE: could set resolve specific to operator to avoid the switch at bind time
		switch operator {
			// NOTE: order is roughly in expected frequency
			case YS_TOKEN.EQUAL_EQUAL:
			case YS_TOKEN.EQUALS:
				// TODO: per type logic here (arrays, structs, ?)
				return left_val == right.resolve(data);
				
			case YS_TOKEN.BANG_EQUAL:
				return left_val != right.resolve(data);
				
			case YS_TOKEN.AND:
				return left_val && right.resolve(data);
				
			case YS_TOKEN.OR:
				return left_val || right.resolve(data);
				
			case YS_TOKEN.PLUS:
				var right_val = right.resolve(data);
				
				if is_string(left_val)
					return left_val + string(right_val);
				else if is_string(right_val)
					return string(left_val) + right_val;
				else
					return left_val + right_val;
				
			case YS_TOKEN.MINUS:
				return left_val - right.resolve(data);
				
			case YS_TOKEN.STAR:
				return left_val * right.resolve(data);
				
			case YS_TOKEN.SLASH:
				return left_val / right.resolve(data);
				
			case YS_TOKEN.GREATER:
				return left_val > right.resolve(data);
				
			case YS_TOKEN.GREATER_EQUAL:
				return left_val >= right.resolve(data);
				
			case YS_TOKEN.LESS:
				return left_val < right.resolve(data);
				
			case YS_TOKEN.LESS_EQUAL:
				return left_val <= right.resolve(data);
				
			case YS_TOKEN.QUESTION_QUESTION:
				return left_val ?? right.resolve(data);
				
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
		var right_val = right.resolve(data);
		
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