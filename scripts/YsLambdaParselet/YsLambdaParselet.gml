/// @description
function YsLambdaParselet(precedence) : GsplInfixParselet(precedence) constructor {
	
	static parse = function(parser, left_expr, token) {
		
		// NOTE: only supports one param currently
		var param = left_expr.resolve();
		
		// set up the args -> param lookup
		parser.context.arg_map = [param];
		
		var body = parser.parseExpression(precedence);
		
		var lambda = new YuiLambda(body, parser.context);
		
		if YUI_COMPILER_ENABLED {
			if parser.level > 1 {
				yui_log(parser.source);
			}
			//yui_compile_binding(lambda, parser.source);
		}
		
		return lambda;
	}
}