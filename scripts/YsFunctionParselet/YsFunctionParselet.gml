// TODO next major version - rename to YsIdentifierParselet
/// @description
function YsFunctionParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		
		if variable_struct_exists(parser.context, "arg_map")
			&& parser.context.arg_map[0] == token._literal {
			return new YuiLambdaVariable(token._literal, parser.context);	
		}
		
		var identifier = token._lexeme;
		return new YuiIdentifier(identifier);
	}
}