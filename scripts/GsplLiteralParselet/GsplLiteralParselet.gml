/// @description
function GsplLiteralParselet() : GsplPrefixParselet() constructor {
	
	static parse = function(parser, token) {
		return new parser.Literal(token._literal, token._type);
	}
	
}