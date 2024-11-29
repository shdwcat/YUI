/// @description parses List (aka Array) literal expressions
function GsplListParselet(list_separator_token, list_end_token)
	: GsplPrefixParselet() constructor {
		
	self.list_separator_token = list_separator_token;
	self.list_end_token = list_end_token;

	static parse = function(parser, token) {
		
		var item_exprs = [];
		
		if !parser.match(list_end_token) {
			
			// parse the list items
			do {
				var expr = parser.parseExpression();
				array_push(item_exprs, expr);
			} until !parser.match(list_separator_token)
			
			parser.consume(list_end_token, "expect ']' after list expression");
		}
		
		return new parser.List(item_exprs);
	}
	
}