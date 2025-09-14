/// @description
function GsplBinaryOperatorParselet(precedence, is_right) : GsplInfixParselet(precedence) constructor {
	self.is_right = is_right;
	
	// when right associative, parse the right_expr with lower precedence
	right_precedence = is_right ? precedence - 1 : precedence;
	
	static parse = function(parser, left_expr, token) {
		
		var right_expr = parser.parseExpression(right_precedence);
		
		var expr = new parser.BinaryOperator(left_expr, token, right_expr);
		
		// TODO ?? should get its own parselet instead of handled by YuiOperationBinding
		// then this would go in that parselet
		if is_instanceof(left_expr, YuiBinding) && left_expr.optional {
			parser.markDataPathOptional(left_expr.path);
		}
		
		return expr;
	}
	
}