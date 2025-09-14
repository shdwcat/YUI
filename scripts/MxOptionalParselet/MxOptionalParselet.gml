/// @description here
function MxOptionalParselet(precedence) : GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
		
		var operation = parser.parseInfix(left_expr, precedence);
		
		if is_instanceof(left_expr, YuiBinding) {
			left_expr.optional = true;
			parser.markDataPathOptional(left_expr.path);
		}
		
		return new MxOptionalExpr(left_expr, operation, parser.source);
	}
}