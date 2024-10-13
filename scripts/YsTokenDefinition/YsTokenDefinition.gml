function ys_token_definition() {
	static definition = new YsTokenDefinition();
	return definition;
}

/// @description YuiScript token definition
function YsTokenDefinition() 
	: GsplTokenDefinition(
		YS_TOKEN.EOF,
		YS_TOKEN.STRING,
		YS_TOKEN.NUMBER,
		YS_TOKEN.IDENTIFIER
	) constructor {

	self.token_type = YsToken;
	
	self.keywords = makeKeywordMap();
	
	static makeKeywordMap = function() {
		var map = {};
		map[$"equals"] = YS_TOKEN.EQUALS;
		map[$"not"] = YS_TOKEN.NOT;
		map[$"and"] = YS_TOKEN.AND;
		map[$"or"] = YS_TOKEN.OR;
		map[$"then"] = YS_TOKEN.THEN;
		map[$"else"] = YS_TOKEN.ELSE;
		map[$"true"] = YS_TOKEN.TRUE;
		map[$"false"] = YS_TOKEN.FALSE;
		map[$"undefined"] = YS_TOKEN.UNDEFINED;
		return map;
	}
}