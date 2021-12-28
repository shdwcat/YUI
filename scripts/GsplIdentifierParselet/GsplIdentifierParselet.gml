/// @description example identifier parselet
function GsplIdentifierParselet() : GsplPrefixParselet() constructor {
	
	static parse = function(parser, token) {
		return new parser.Identifier(token._literal);
	}
	
}