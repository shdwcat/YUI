/// @description
function GsplInfixCallParselet(precedence) : GsplInfixParselet(precedence) constructor {

	static parse = function(parser, left_expr, token) {
		
		// using CALL precedence so that we don't pick up anything after the call
		// e.g. given:
		//     foo |> call() + bar
		// the following line will only pick up the 'call()' not the '+ bar'
		var call = parser.parseExpression(YS_PRECEDENCE.CALL - 0.5);
		
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