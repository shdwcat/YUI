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
	SUM =         9,
	PRODUCT =     10,
	PREFIX =      11,
	CALL =        12, // also subscript (e.g. member access and indexing)
}