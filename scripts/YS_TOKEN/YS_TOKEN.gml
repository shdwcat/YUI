enum YS_TOKEN {
	// syntax
	LEFT_PAREN, RIGHT_PAREN,
	LEFT_BRACKET, RIGHT_BRACKET,
	DOT, // member access
	COMMA, // function args
	PIPE_GREATER, // |> infix function call
	GREATER_GREATER, // >> infix function call
	ARROW, // => lambda definition
	QUESTION, COLON, // ? : ternary
	QUESTION_QUESTION, // ?? null coalesce
	PIPE, // directives
	EQUAL, // assignment
	
	// string ops
	STRING_PLUS,
	
	// math
	MINUS, PLUS,
	SLASH, STAR,
	// div/mod?
	
	// NOTE: currently unused
	BANG, 
	
	// logic
	BANG_EQUAL,	EQUAL_EQUAL,
	GREATER, GREATER_EQUAL,
	LESS, LESS_EQUAL,
	
	// keywords
	EQUALS, NOT,
	AND, OR,
	THEN, ELSE,
	
	// can these by like a paired expression?
	// e.g. @,$,#,! are prefix operators?
	
	// primary
	IDENTIFIER, // plain identifier (for subscript and lambdas)
	BINDING_IDENTIFIER, // @bind
	SLOT_IDENTIFIER, // $slot
	RESOURCE_IDENTIFIER, // &resource
	HOST_IDENTIFIER, // ~host
	
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