/// @description
function YsBindingParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		var path = token._lexeme;
		return new YuiBinding(path);
	}
}