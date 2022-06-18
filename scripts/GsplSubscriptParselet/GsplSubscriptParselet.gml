/// @description parses the '.' in 'foo.bar'
function GsplSubscriptParselet(precedence, identifier_token, second_token) : GsplInfixParselet(precedence) constructor {
	
	self.identifier_token = identifier_token;
	self.second_token = second_token;

	static parse = function(parser, left_expr, token) {
		
		if parser.match(identifier_token, second_token) {
			var identifier = parser.previous();
		}
		else {
			throw parser.parser_error(peek(), "expecting identifier token");
		}
		
		return new parser.Subscript(left_expr, identifier._lexeme);
	}
	
}