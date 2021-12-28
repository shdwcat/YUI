/// @description
function GsplCallParselet(precedence, arg_separator_token, args_end_token)
	: GsplInfixParselet(precedence) constructor {
		
	self.arg_separator_token = arg_separator_token;
	self.args_end_token = args_end_token;

	static parse = function(parser, left_expr, token) {
		
		var args = [];
		
		if !parser.match(args_end_token) {
			
			// parse the args
			do {
				var arg = parser.parseExpression();
				array_push(args, arg);
			} until !parser.match(arg_separator_token)
			
			parser.consume(args_end_token);
		}
		
		return new parser.Call(left_expr, args);
	}
	
}