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
	
	switch self.operator {
		case YS_TOKEN.EQUAL_EQUAL:
		case YS_TOKEN.EQUALS:
			self.resolve = function ys_operator_equals(data) {
				var left_val = left.resolve(data);
				return left_val == right.resolve(data);
			};
			break;
		case YS_TOKEN.QUESTION_QUESTION:
			self.resolve = function ys_operator_null_coalesce(data) {
				var left_val = left.resolve(data);
				return left_val ?? right.resolve(data);
			};
			break;
				
		case YS_TOKEN.BANG_EQUAL:
			self.resolve = function ys_operator_not_equals(data) {
				var left_val = left.resolve(data);
				return left_val != right.resolve(data);
			};
			break;
				
		case YS_TOKEN.AND:
			self.resolve = function ys_operator_and(data) {
				var left_val = left.resolve(data);
				return left_val and right.resolve(data);
			};
			break;
				
		case YS_TOKEN.OR:
			self.resolve = function ys_operator_or(data) {
				var left_val = left.resolve(data);
			return left_val or right.resolve(data);
			};
			break;
				
		case YS_TOKEN.STRING_PLUS:
			self.resolve = function ys_operator_concat(data) {
				var left_val = left.resolve(data);
				return string(left_val) + string(right.resolve(data));
			};
			break;
				
		case YS_TOKEN.PLUS:
			self.resolve = function ys_operator_add(data) {
				var left_val = left.resolve(data);
				var right_val = right.resolve(data);
				
				if is_string(left_val)
					return left_val + string(right_val);
				else if is_string(right_val)
					return string(left_val) + right_val;
				else
					return left_val + right_val;
				};
			break;
				
		case YS_TOKEN.MINUS:
			self.resolve = function ys_operator_subtract(data) {
				var left_val = left.resolve(data);
				return left_val - right.resolve(data);
			};
			break;
				
		case YS_TOKEN.STAR:
			self.resolve = function ys_operator_multiply(data) {
				var left_val = left.resolve(data);
				return left_val * right.resolve(data);
			};
			break;
				
		case YS_TOKEN.SLASH:
			self.resolve = function ys_operator_divide(data) {
				var left_val = left.resolve(data);
				return left_val / right.resolve(data);
			};
			break;
		case YS_TOKEN.GREATER:
			self.resolve = function ys_operator_greater_than(data) {
				var left_val = left.resolve(data);
				return left_val > right.resolve(data);
			};
			break;
				
		case YS_TOKEN.GREATER_EQUAL:
			self.resolve = function ys_operator_greater_than_or_equal(data) {
				var left_val = left.resolve(data);
				return left_val >= right.resolve(data);
			};
			break;
				
		case YS_TOKEN.LESS:
			self.resolve = function ys_operator_less_than(data) {
				var left_val = left.resolve(data);
				return left_val < right.resolve(data);
			};
			break;
				
		case YS_TOKEN.LESS_EQUAL:
			self.resolve = function ys_operator_less_than_or_equal(data) {
				var left_val = left.resolve(data);
				return left_val <= right.resolve(data);
			};
				
		default:
			throw yui_error("Unknown operator: " + operator_name);
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
function YuiPrefixOperatorBinding(operatorToken, right) : YuiExpr() constructor {
	static is_yui_binding = true;
	static is_yui_live_binding = true;

	self.token = operatorToken
	self.operator = operatorToken._type;
	self.right = right;
	
	static resolve = function(data)
	{
		var right_val = right.resolve(data);
		
		// NOTE: could set resolve specific to operator to avoid the switch at bind time
		switch operator {
			// NOTE: order is roughly in expected frequency
			case YS_TOKEN.NOT:
				return !right_val;
			case YS_TOKEN.MINUS:
				return -right_val;
				
			default:
				throw gspl_log("Unknown operator: " + token.getTokenName());
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