/// @description
function GsplIndexerParselet(precedence, indexer_end_token) : GsplInfixParselet(precedence) constructor {

	self.indexer_end_token = indexer_end_token;

	static parse = function(parser, left_expr, token) {
		
		var index_expr = parser.parseExpression(precedence - 1);
		
		parser.consume(indexer_end_token, "Expecting ']' after index key.");
		
		return new parser.Indexer(left_expr, index_expr);
	}
	
}