enum KNIT_TOKEN {
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