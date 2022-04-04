/// @description
function GsplInfixCallParselet(precedence): GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
				
		var call = parser.parseExpression();
		
		// HACK: assumes the call result has an args array
		// TODO: move this to YsInfixCallParselet instead of in gspl?
		array_insert(call.args, 0, left_expr);
		call.arg_count++;
		
		return call;
	}
	
}