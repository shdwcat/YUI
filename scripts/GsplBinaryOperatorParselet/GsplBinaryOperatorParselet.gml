/// @description
function GsplBinaryOperatorParselet(precedence, is_right) : GsplInfixParselet(precedence) constructor {
	self.is_right = is_right;
	
	static parse = function(parser, left_expr, token) {
		
		// when right associative, parse the right_expr with lower precedence
		right_precedence = is_right ? precedence - 1 : precedence;
		
		right_expr = parser.parseExpression(right_precedence);
		
		return new parser.BinaryOperator(left_expr, token, right_expr);
	}
	
}