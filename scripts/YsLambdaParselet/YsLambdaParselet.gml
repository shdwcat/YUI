/// @description
function YsLambdaParselet(precedence) : GsplInfixParselet(precedence) constructor {
	
	static parse = function(parser, left_expr, token) {
		
		// NOTE: only supports one param currently
		var param = left_expr.resolve();
		
		// set up the args -> param lookup
		parser.context.arg_map = [param];
		
		var body = parser.parseExpression(precedence);
		
		var lambda = new YuiLambda(body, parser.context);
		return lambda;
	}
}