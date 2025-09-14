/// @description
function YsBindingParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		
		// track the data bindings used in the expression
		parser.trackDataPath(token._lexeme);
		
		var path = token._lexeme;
		return new YuiBinding(path);
	}
}