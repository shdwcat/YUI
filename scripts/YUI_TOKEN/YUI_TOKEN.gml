/// @description
enum YUI_TOKEN {
	// syntax
	LEFT_PAREN, RIGHT_PAREN,
	LEFT_BRACKET, RIGHT_BRACKET,
	COMMA, // flow separator
	COLON, // key/value separator
	DASH, // array item indicator
	SLASH, // comment
	
	// can these by like a paired expression?
	// e.g. @,$,#,! are prefix operators?
	
	// primary
	KEY,
	
	// values
	STRING,
	NUMBER,
	COLOR,
	
	// literals
	TRUE, FALSE,
	NULL,
	
	// EOF
	EOF,
}