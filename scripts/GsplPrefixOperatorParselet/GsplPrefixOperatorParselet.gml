/// @description
function GsplPrefixOperatorParselet(precedence) : GsplPrefixParselet() constructor {
	
	self.precedence = precedence;
	
	static parse = function(parser, token) {
		var right_expr = parser.parseExpression(precedence);
		return new parser.PrefixOperator(token, right_expr);
	}
	
}