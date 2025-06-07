/// @description YuiScript operator precedence
enum YS_PRECEDENCE {
	// applies last
	DIRECTIVE =   1,
	
	LAMBDA =      2,
	ASSIGNMENT =  3,
	CHAIN =       4,
	CONDITIONAL = 5,
	LOGIC_OR =    6,
	LOGIC_AND =   7,
	COMPARISON =  8,
	EQUALITY =    9,
	STRING_OP =   10,
	SUM =         11,
	PRODUCT =     12,
	PREFIX =      13,
	CALL =        14, // also subscript (e.g. member access and indexing)
}