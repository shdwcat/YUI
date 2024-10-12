/// @description
function GsplInfixCallParselet(precedence): GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
				
		var call = parser.parseExpression();
		
		if !variable_struct_exists(call, "args") {
			throw "expected Call expression to have args";
		}
		
		array_insert(call.args, 0, left_expr);
		call.arg_count++;
		
		return call;
	}
	
}