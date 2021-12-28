/// @description
function GsplPrefixCallParselet(
	precedence,
	func_identifier_token,
	arg_separator_token,
	args_end_token
	) constructor {
		
	self.func_identifier_token = func_identifier_token;
	self.arg_separator_token = arg_separator_token;
	self.args_end_token = args_end_token;

	static parse = function(parser, token) {
		
		var args = [];
		
		var func_name = parser.consume(func_identifier_token, "Expecting function name after '>>'");
		
		// skip the args start token
		parser.advance();
		
		if !parser.match(args_end_token) {
			
			// parse the args
			do {
				var arg = parser.parseExpression();
				array_push(args, arg);
			} until !parser.match(arg_separator_token)
			
			parser.consume(args_end_token, "Expecting ')' after argument list");
		}
		
		return new parser.Call(func_name._lexeme, args);
	}
	
}