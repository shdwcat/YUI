/// @description here
function MxOptionalParselet(precedence) : GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
		
		var operation = parser.parseInfix(left_expr, precedence);
		
		return new MxOptionalExpr(left_expr, operation, parser.source);
	}
}