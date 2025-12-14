/// @description here
function MxIdentifierParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		
		if parser.context 
			and struct_exists(parser.context, "arg_map")
			and array_contains(parser.context.arg_map, token._literal) {
			return new YuiLambdaVariable(token._literal, parser.context);	
		}
		
		var identifier = token._lexeme;
		return new parser.Identifier(identifier, parser.source);
	}
}