/// @description
function GsplSubscriptParselet(precedence, identifier_token) : GsplInfixParselet(precedence) constructor {
	
	self.identifier_token = identifier_token

	static parse = function(parser, left_expr, token) {
		
		var identifier = parser.consume(identifier_token);
		
		return new parser.Subscript(left_expr, identifier._lexeme);
	}
	
}