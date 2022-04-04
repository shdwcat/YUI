/// @description
function YsStringLiteralParselet() : GsplPrefixParselet() constructor {
	
	static parse = function(parser, token) {
		
		// TODO: this will match a quoted string and not just a plain string, need to fix that
		
		// check if this is actually a lambda variable name
		// NOTE: quick hack just checks the first arg, would need a param names list for multiple params
		if variable_struct_exists(parser.context, "arg_map")
			&& parser.context.arg_map[0] == token._literal {
			return new YuiLambdaVariable(token._literal, parser.context);	
		}
		
		return new parser.Literal(token._literal, token._type);
	}
	
}