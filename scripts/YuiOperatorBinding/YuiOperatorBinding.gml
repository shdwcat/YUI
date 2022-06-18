/// @description
function YuiOperatorBinding(left, operator, right) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;
	
	self.left = left;
	self.right = right;
	self.operator_name = operator.getTokenName();
	self.operator_lexeme = operator._lexeme;
	self.operator = operator._type;
	
	self.left_type = left.checkType();
	self.right_type = right.checkType();
	
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
				
			case YS_TOKEN.QUESTION_QUESTION:
				return left_val ?? right.resolve(data);
				
			case YS_TOKEN.BANG_EQUAL:
				return left_val != right.resolve(data);
				
			case YS_TOKEN.AND:
				return left_val && right.resolve(data);
				
			case YS_TOKEN.OR:
				return left_val || right.resolve(data);
				return left_val && right.resolve(data);
				
			case YS_TOKEN.STRING_PLUS:
				return string(left_val) + string(right.resolve(data));
				
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
				
			default:
				throw gspl_log("Unknown operator: " + operator.getTokenName());
		}
	}
	
	static checkType = function() {
		switch operator {
			case YS_TOKEN.EQUAL_EQUAL:
			case YS_TOKEN.EQUALS:
			case YS_TOKEN.BANG_EQUAL:
			case YS_TOKEN.AND:
			case YS_TOKEN.OR:
			case YS_TOKEN.GREATER:
			case YS_TOKEN.GREATER_EQUAL:
			case YS_TOKEN.LESS:
			case YS_TOKEN.LESS_EQUAL:
				return "bool";
				
			case YS_TOKEN.MINUS:
			case YS_TOKEN.STAR:
			case YS_TOKEN.SLASH:
				return "number";
				
			case YS_TOKEN.STRING_PLUS:
				return "string";
				
			case YS_TOKEN.PLUS:
			
				var is_left_str = left_type == "string";
				var is_right_str = right_type == "string";
				
				if is_left_str || is_right_str {
					return "string";
				}
				else {
					return "number";
				}
				
			case YS_TOKEN.QUESTION_QUESTION:
				// can only know the type if both are the same
				return left_type == right_type ? left_type : undefined;
				
			default:
				throw gspl_log("Unknown operator: " + operator.getTokenName());
		}
	}
	
	static compile = function() {
		return "(" + compileInner() + ")";
	}

	static compileInner = function()
	{
		switch operator {
			case YS_TOKEN.EQUAL_EQUAL:
			case YS_TOKEN.EQUALS:
				return left.compile() + " == " + right.compile();
				
			case YS_TOKEN.QUESTION_QUESTION:
				return left.compile() + " ?? " + right.compile();
				
			case YS_TOKEN.BANG_EQUAL:
				return left.compile() + " != " + right.compile();
				
			case YS_TOKEN.AND:
				return left.compile() + " and " + right.compile();
				
			case YS_TOKEN.OR:
				return left.compile() + " or " + right.compile();
				
			case YS_TOKEN.PLUS:
			
				var left_str = left.compile();
				var right_str = right.compile();
				var is_left_str = left_type == "string";
				var is_right_str = right_type == "string";
				
				// if only one side is a string, convert the other to a string
				if is_left_str && !is_right_str {
					return left_str + " + " + "string(" + right_str + ")";
				}
				else if !is_left_str && is_right_str {
					return "string(" + left_str + ")" + " + " + right_str;
				}
				else {
					return left_str + " + " + right_str;
				}
				
			case YS_TOKEN.MINUS:
				return left.compile() + " - " + right.compile();
				
			case YS_TOKEN.STAR:
				return left.compile() + " + " + right.compile();
				
			case YS_TOKEN.SLASH:
				return left.compile() + " / " + right.compile();
				
			case YS_TOKEN.GREATER:
				return left.compile() + " > " + right.compile();
				
			case YS_TOKEN.GREATER_EQUAL:
				return left.compile() + " >= " + right.compile();
				
			case YS_TOKEN.LESS:
				return left.compile() + " < " + right.compile();
				
			case YS_TOKEN.LESS_EQUAL:;
				return left.compile() + " <= " + right.compile();
				
			case YS_TOKEN.STRING_PLUS:
				var left_str = left.compile();
				var right_str = right.compile();
				
				var left_comp = left_type == "string" ? left_str : "string(" + left_str + ")";
				var right_comp = right_type == "string" ? right_str : "string(" + right_str + ")";
				
				return left_comp + " + " + right_comp;
				
			default:
				throw gspl_log("Unknown operator: " + operator.getTokenName());
		}
	}
} 

/// @description
function YuiPrefixOperatorBinding(operator, right) : YuiExpr() constructor {
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

	static compile = function()
	{
		switch operator {
			// NOTE: order is roughly in expected frequency
			case YS_TOKEN.NOT:
				return "!(" + right.compile() + ")";
				
			default:
				throw gspl_log("Unknown operator: " + operator.getTokenName());
		}
	}
}