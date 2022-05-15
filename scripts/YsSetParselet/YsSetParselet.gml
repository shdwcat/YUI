/// @description
function YsSetParselet(precedence)
	: GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
		
		var expr_type = instanceof(left_expr);
		
		// reverse parse the left algorithm to get the 'parent' expression and the field name to assign to
		if expr_type == "YuiBinding" {
			if left_expr.resolver == left_expr.resolveToken {
				var name = left_expr.token;
				left_expr = new YuiBinding("");
			}
			else if left_expr.resolver == left_expr.resolveTokenArray {
				var token_count = array_length(left_expr.tokens);
				var name = left_expr.tokens[token_count - 1];
				array_resize(left_expr.tokens, token_count - 1);
			}
			else {
				throw yui_error("Cannot set value on a binding with an empty path (e.g. '@')");
			}
		}
		else if expr_type == "YuiValueBinding" {
			if left_expr.resolver == left_expr.resolveToken {
				var name = left_expr.token;
				left_expr = new YuiBinding("");
			}
			else if left_expr.resolver == left_expr.resolveTokenArray {
				var token_count = array_length(left_expr.tokens);
				var name = left_expr.tokens[token_count - 1];
				array_resize(left_expr.tokens, token_count - 1);
			}
			else {
				throw yui_error("Cannot set value on a ValueBinding with an empty path (e.g. '@')");
			}
		}
		else if expr_type == "YuiSubscript" {
			var name = left_expr.variable_name;
			left_expr = left_expr.expr;
		}
		else if expr_type = "YuiIndexBinding" {
			// needs special casing since we can't set array indexes the same way as struct variables
			var index = left_expr.index;
			left_expr = left_expr.left_expr;
			var right_expr = parser.parseExpression(precedence);
			return new YuiSetIndex(left_expr, index, right_expr);
		}
		else {
			throw yui_error("SetValue is not supported on expression of type " + expr_type);
		}
		
		// create the Set expression
		var right_expr = parser.parseExpression(precedence);
		return new parser.Set(left_expr, name, right_expr);
	}
	
}


