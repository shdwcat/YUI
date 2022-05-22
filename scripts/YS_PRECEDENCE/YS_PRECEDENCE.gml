/// @description YuiScript operator precedence
enum YS_PRECEDENCE {
	// applies last
	DIRECTIVE =   1,
	
	LAMBDA =      2,
	ASSIGNMENT =  3,
	CONDITIONAL = 4,
	LOGIC_OR =    5,
	LOGIC_AND =   6,
	COMPARISON =  7,
	EQUALITY =    8,
	STRING_OP =   9,
	SUM =         10,
	PRODUCT =     11,
	PREFIX =      12,
	CALL =        13, // also subscript (e.g. member access and indexing)
}