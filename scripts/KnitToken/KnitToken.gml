/// @description token class for Knit
function KnitToken(type, lexeme, literal, line) : GsplToken(type, lexeme, literal, line) constructor {

	static getTokenName = get_gscript_token_name;
}

function get_gscript_token_name(token_type) {
	
	static type_map = make_gscript_type_map();
	
	var name = type_map[token_type];
	return name == undefined
		? "no name defined for token type: " + string(token_type)
		: name;		
}

function make_gscript_type_map() {
	var type_map = array_create(KNIT_TOKEN.EOF + 1);
	type_map[KNIT_TOKEN.LEFT_PAREN] = "LEFT_PAREN";
	type_map[KNIT_TOKEN.RIGHT_PAREN] = "RIGHT_PAREN";
	type_map[KNIT_TOKEN.LEFT_BRACE] = "LEFT_BRACE";
	type_map[KNIT_TOKEN.RIGHT_BRACE] = "RIGHT_BRACE";
	type_map[KNIT_TOKEN.LEFT_BRACKET] = "LEFT_BRACKET";
	type_map[KNIT_TOKEN.RIGHT_BRACKET] = "RIGHT_BRACKET";
	type_map[KNIT_TOKEN.DOT] = "DOT";
	type_map[KNIT_TOKEN.DOT_DOT] = "DOT_DOT";
	type_map[KNIT_TOKEN.QUESTION_DOT] = "QUESTION_DOT";
	type_map[KNIT_TOKEN.COMMA] = "COMMA";
	type_map[KNIT_TOKEN.SEMICOLON] = "SEMICOLON";
		
	type_map[KNIT_TOKEN.BANG] = "BANG";
	type_map[KNIT_TOKEN.EQUAL] = "EQUAL";
	type_map[KNIT_TOKEN.BANG_EQUAL] = "BANG_EQUAL";
	type_map[KNIT_TOKEN.EQUAL_EQUAL] = "EQUAL_EQUAL";
	
	type_map[KNIT_TOKEN.IF] = "IF";
	type_map[KNIT_TOKEN.ELSE] = "ELSE";
	
	type_map[KNIT_TOKEN.GREATER_EQUAL] = "GREATER_EQUAL";
	type_map[KNIT_TOKEN.GREATER] = "GREATER";
	type_map[KNIT_TOKEN.LESS_EQUAL] = "LESS_EQUAL";
	type_map[KNIT_TOKEN.LESS] = "LESS";
		
	type_map[KNIT_TOKEN.MINUS] = "MINUS";
	type_map[KNIT_TOKEN.PLUS] = "PLUS";
	type_map[KNIT_TOKEN.SLASH] = "SLASH";
	type_map[KNIT_TOKEN.STAR] = "STAR";
		
	type_map[KNIT_TOKEN.IDENTIFIER] = "IDENTIFIER";
	type_map[KNIT_TOKEN.NUMBER] = "NUMBER";
	type_map[KNIT_TOKEN.STRING] = "STRING";
	
	type_map[KNIT_TOKEN.YIELD] = "YIELD";
	type_map[KNIT_TOKEN.RETURN] = "RETURN";
	type_map[KNIT_TOKEN.VAR] = "VAR";	
	type_map[KNIT_TOKEN.AND] = "AND";
	type_map[KNIT_TOKEN.OR] = "OR";
	
	type_map[KNIT_TOKEN.TRUE] = "TRUE";
	type_map[KNIT_TOKEN.FALSE] = "FALSE";
	type_map[KNIT_TOKEN.NULL] = "NULL";
	type_map[KNIT_TOKEN.DONE] = "DONE";
	
	type_map[KNIT_TOKEN.DO] = "DO";
	type_map[KNIT_TOKEN.FOR] = "FOR";
	type_map[KNIT_TOKEN.EACH] = "EACH";
	type_map[KNIT_TOKEN.EVERY] = "EVERY";
	type_map[KNIT_TOKEN.IN] = "IN";
	type_map[KNIT_TOKEN.DISTINCT] = "DISTINCT";
	type_map[KNIT_TOKEN.COLLECT] = "COLLECT";
	type_map[KNIT_TOKEN.BREAK] = "BREAK";
	
	type_map[KNIT_TOKEN.PARALLEL] = "PARALLEL";
	type_map[KNIT_TOKEN.ANIMATE] = "ANIMATE";
	type_map[KNIT_TOKEN.KEYFRAME] = "KEYFRAME";
	type_map[KNIT_TOKEN.FRAME] = "FRAME";
	type_map[KNIT_TOKEN.DELAY] = "DELAY";
	type_map[KNIT_TOKEN.WHEN] = "WHEN";
	type_map[KNIT_TOKEN.EMIT] = "EMIT";
	
	type_map[KNIT_TOKEN.EVENT] = "EVENT";
	type_map[KNIT_TOKEN.DRAW] = "DRAW";
	type_map[KNIT_TOKEN.DRAWGUI] = "DRAWGUI";
	
	type_map[KNIT_TOKEN.PRINT] = "PRINT";
	type_map[KNIT_TOKEN.EOF] = "EOF";
	return type_map;
}