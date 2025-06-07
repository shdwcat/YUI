/// @description here
function GsplTraceParselet(precedence) : GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token, precedence) {
		parser.trace = true;
		
		parser.log("TraceInfix: left_expr is:");
		parser.traceExpr(left_expr);
		
		// re-use the outer precedence so we don't disrupt the parsing
		var operation = parser.parseInfix(left_expr, precedence);
		operation.trace = true;
		
		parser.log("TraceInfix: Result expr is:");
		parser.traceExpr(operation);
		
		parser.trace = false;
		return operation;
	}
}