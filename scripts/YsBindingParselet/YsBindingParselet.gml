/// @description
function YsBindingParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		var path = token._lexeme;
		var expr = { path: path };
		return new YuiBinding(expr, path, {});
	}
}