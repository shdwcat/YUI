/// @description
function YsFunctionParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		var func_name = token._lexeme;
		return func_name;
	}
}