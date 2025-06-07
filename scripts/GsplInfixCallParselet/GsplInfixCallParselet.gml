/// @description
function GsplInfixCallParselet(precedence) : GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
		
		// using our defined precedence makes this act as a left-associative operator
		var call = parser.parseExpression(precedence);
		
		if !variable_struct_exists(call, "args") {
			throw "expected Call expression to have args";
		}
		
		// insert left_expr as the first argument in the call expr defined on the right
		// TODO: could scan args for % to place arg arbitrarily
		array_insert(call.args, 0, left_expr);
		call.arg_count++;
		
		return call;
	}
	
}