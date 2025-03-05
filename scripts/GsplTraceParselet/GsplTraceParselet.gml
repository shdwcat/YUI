/// @description here
function GsplTraceParselet(precedence) : GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
		
		gspl_log("Tracing operation, left_expr is:");
		parser.traceExpr(left_expr);
		
		parser.trace = true;
		var operation = parser.parseInfix(left_expr, precedence);
		parser.trace = false;
		
		operation.trace = true;
		return operation;
	}
}