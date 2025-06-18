/// @description here
function MxSpreadParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		
		var right_expr = parser.parseExpression(YS_PRECEDENCE.PREFIX);
		
		return new MxSpreadExpr(right_expr, parser.source);
	}
}