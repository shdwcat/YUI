/// @description
function GsplConditionalParselet(precedence, colon_token) : GsplInfixParselet(precedence) constructor {

	self.colon_token = colon_token;

	static parse = function(parser, left_expr, token) {
		
		var then_expr = parser.parseExpression();
		parser.consume(colon_token, "Expecting ':' for conditional (?:) expression");
		var else_expr = parser.parseExpression(precedence - 1);
		
		return new parser.Conditional(left_expr, then_expr, else_expr);
	}
	
}