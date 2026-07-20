/// @description here
function MxIdentifierParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		
		if parser.lambda_context {
			if parser.lambda_context.isParamIdentifier(token._literal) {
				// NOTE: currently for an identifier matching an outer lambda param this
				// will still associate it with the 'lowest' context, which means YuiLambdaVariable
				// has to search up the chain for the value. If we could store the matching context
				// we wouldn't need to do that (and means we lambdas could be called recursively,
				// though currently there is no way to make a recursive lambda invocation)
				return new YuiLambdaVariable(token._literal, parser.lambda_context);
			}
		}
		
		var identifier = token._lexeme;
		return new parser.Identifier(identifier, parser.source);
	}
}