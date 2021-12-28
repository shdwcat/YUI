enum GS_TOKEN {
	// syntax
	LEFT_PAREN, RIGHT_PAREN,
	LEFT_BRACE, RIGHT_BRACE,
	LEFT_BRACKET, RIGHT_BRACKET,
	DOT,
	QUESTION_DOT,
	COMMA,
	SEMICOLON,
	
	// range
	DOT_DOT,
	
	// logic
	BANG, EQUAL,
	BANG_EQUAL,	EQUAL_EQUAL,
	GREATER, GREATER_EQUAL,
	LESS, LESS_EQUAL,
	IF, ELSE,
	
	// math
	MINUS, PLUS,
	SLASH, STAR,
	// div/mod?
	
	// math assign
	MINUS_EQUAL, PLUS_EQUAL,
	
	// primary
	IDENTIFIER,
	NUMBER,
	STRING,
	
	// keywords
	YIELD, // TODO
	RETURN, // TODO
	VAR,
	AND, OR,
	
	// literals
	TRUE, FALSE,
	NULL, // change to NOTHING?
	DONE,
	
	// iteration
	DO, // TODO
	FOR,
	EACH, EVERY, // TODO
	IN, // TODO
	DISTINCT, // TODO
	COLLECT, // TODO
	BREAK,
	
	// fibers
	PARALLEL, // TODO
	ANIMATE,
	DELAY,
	KEYFRAME,
	FRAME,
	WHEN, // TODO
	EMIT, // TODO
	
	// event scheduling
	EVENT,
	DRAW,
	DRAWGUI,
	
	// output
	PRINT,
	
	// EOF
	EOF,
}

function GsTokenDefinition()
	: GsplTokenDefinition(
		GS_TOKEN.EOF,
		GS_TOKEN.STRING,
		GS_TOKEN.NUMBER,
		GS_TOKEN.IDENTIFIER) constructor {
	
	self.token_type = GsToken;
	
	self.keywords = makeKeywordMap();
	
	static makeKeywordMap = function() {
		var map = {
			yield: GS_TOKEN.YIELD,
			null: GS_TOKEN.NULL,
			done: GS_TOKEN.DONE,
			each: GS_TOKEN.EACH,
			every: GS_TOKEN.EVERY,
			in: GS_TOKEN.IN,
			distinct: GS_TOKEN.DISTINCT,
			collect: GS_TOKEN.COLLECT,
			parallel: GS_TOKEN.PARALLEL,
			animate: GS_TOKEN.ANIMATE,
			delay: GS_TOKEN.DELAY,
			keyframe: GS_TOKEN.KEYFRAME,
			frame: GS_TOKEN.FRAME,
			when: GS_TOKEN.WHEN,
			emit: GS_TOKEN.EMIT,
			print: GS_TOKEN.PRINT,
			event: GS_TOKEN.EVENT,
			draw: GS_TOKEN.DRAW,
			drawgui: GS_TOKEN.DRAWGUI,
		}
		map[$"if"] = GS_TOKEN.IF;
		map[$"else"] = GS_TOKEN.ELSE;
		map[$"return"] = GS_TOKEN.RETURN;
		map[$"and"] = GS_TOKEN.AND;
		map[$"or"] = GS_TOKEN.OR;
		map[$"true"] = GS_TOKEN.TRUE;
		map[$"false"] = GS_TOKEN.FALSE;
		map[$"var"] = GS_TOKEN.VAR;
		map[$"do"] = GS_TOKEN.DO;
		map[$"for"] = GS_TOKEN.FOR;
		map[$"break"] = GS_TOKEN.BREAK;
		return map;
	}
}

/// @description token class for GScript
function GsToken(type, lexeme, literal, line) : Token(type, lexeme, literal, line) constructor {

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
	var type_map = array_create(GS_TOKEN.EOF + 1);
	type_map[GS_TOKEN.LEFT_PAREN] = "LEFT_PAREN";
	type_map[GS_TOKEN.RIGHT_PAREN] = "RIGHT_PAREN";
	type_map[GS_TOKEN.LEFT_BRACE] = "LEFT_BRACE";
	type_map[GS_TOKEN.RIGHT_BRACE] = "RIGHT_BRACE";
	type_map[GS_TOKEN.LEFT_BRACKET] = "LEFT_BRACKET";
	type_map[GS_TOKEN.RIGHT_BRACKET] = "RIGHT_BRACKET";
	type_map[GS_TOKEN.DOT] = "DOT";
	type_map[GS_TOKEN.DOT_DOT] = "DOT_DOT";
	type_map[GS_TOKEN.QUESTION_DOT] = "QUESTION_DOT";
	type_map[GS_TOKEN.COMMA] = "COMMA";
	type_map[GS_TOKEN.SEMICOLON] = "SEMICOLON";
		
	type_map[GS_TOKEN.BANG] = "BANG";
	type_map[GS_TOKEN.EQUAL] = "EQUAL";
	type_map[GS_TOKEN.BANG_EQUAL] = "BANG_EQUAL";
	type_map[GS_TOKEN.EQUAL_EQUAL] = "EQUAL_EQUAL";
	
	type_map[GS_TOKEN.IF] = "IF";
	type_map[GS_TOKEN.ELSE] = "ELSE";
	
	type_map[GS_TOKEN.GREATER_EQUAL] = "GREATER_EQUAL";
	type_map[GS_TOKEN.GREATER] = "GREATER";
	type_map[GS_TOKEN.LESS_EQUAL] = "LESS_EQUAL";
	type_map[GS_TOKEN.LESS] = "LESS";
		
	type_map[GS_TOKEN.MINUS] = "MINUS";
	type_map[GS_TOKEN.PLUS] = "PLUS";
	type_map[GS_TOKEN.SLASH] = "SLASH";
	type_map[GS_TOKEN.STAR] = "STAR";
		
	type_map[GS_TOKEN.IDENTIFIER] = "IDENTIFIER";
	type_map[GS_TOKEN.NUMBER] = "NUMBER";
	type_map[GS_TOKEN.STRING] = "STRING";
	
	type_map[GS_TOKEN.YIELD] = "YIELD";
	type_map[GS_TOKEN.RETURN] = "RETURN";
	type_map[GS_TOKEN.VAR] = "VAR";	
	type_map[GS_TOKEN.AND] = "AND";
	type_map[GS_TOKEN.OR] = "OR";
	
	type_map[GS_TOKEN.TRUE] = "TRUE";
	type_map[GS_TOKEN.FALSE] = "FALSE";
	type_map[GS_TOKEN.NULL] = "NULL";
	type_map[GS_TOKEN.DONE] = "DONE";
	
	type_map[GS_TOKEN.DO] = "DO";
	type_map[GS_TOKEN.FOR] = "FOR";
	type_map[GS_TOKEN.EACH] = "EACH";
	type_map[GS_TOKEN.EVERY] = "EVERY";
	type_map[GS_TOKEN.IN] = "IN";
	type_map[GS_TOKEN.DISTINCT] = "DISTINCT";
	type_map[GS_TOKEN.COLLECT] = "COLLECT";
	type_map[GS_TOKEN.BREAK] = "BREAK";
	
	type_map[GS_TOKEN.PARALLEL] = "PARALLEL";
	type_map[GS_TOKEN.ANIMATE] = "ANIMATE";
	type_map[GS_TOKEN.KEYFRAME] = "KEYFRAME";
	type_map[GS_TOKEN.FRAME] = "FRAME";
	type_map[GS_TOKEN.DELAY] = "DELAY";
	type_map[GS_TOKEN.WHEN] = "WHEN";
	type_map[GS_TOKEN.EMIT] = "EMIT";
	
	type_map[GS_TOKEN.EVENT] = "EVENT";
	type_map[GS_TOKEN.DRAW] = "DRAW";
	type_map[GS_TOKEN.DRAWGUI] = "DRAWGUI";
	
	type_map[GS_TOKEN.PRINT] = "PRINT";
	type_map[GS_TOKEN.EOF] = "EOF";
	return type_map;
}