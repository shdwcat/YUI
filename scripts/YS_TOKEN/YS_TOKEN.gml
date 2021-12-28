enum YS_TOKEN {
	// syntax
	LEFT_PAREN, RIGHT_PAREN,
	LEFT_BRACKET, RIGHT_BRACKET,
	DOT, // member access
	COMMA, // function args
	GREATER_GREATER, // >> prefix/infix function call
	QUESTION, COLON, // ? : ternary
	PIPE, // directives
	
	// math
	MINUS, PLUS,
	SLASH, STAR,
	// div/mod?
	
	// logic
	BANG,
	BANG_EQUAL,	EQUAL_EQUAL,
	GREATER, GREATER_EQUAL,
	LESS, LESS_EQUAL,
	
	// keywords
	EQUALS,
	AND, OR,
	THEN, ELSE,
	
	// can these by like a paired expression?
	// e.g. @,$,#,! are prefix operators?
	
	// primary
	BINDING_IDENTIFIER, // @bind
	SLOT_IDENTIFIER, // $slot
	RESOURCE_IDENTIFIER, // &resource
	
	FUNCTION_IDENTIFIER, // function(
	
	// using ! here means no $foo == !$bar weird...
	SPECIAL_IDENTIFIER, // !special
	
	// values
	STRING,
	NUMBER,
	COLOR, // colors via 6 or 8 digit hex codes prefixed with #
	
	// literals
	TRUE, FALSE,
	UNDEFINED,
	
	// EOF
	EOF,
}