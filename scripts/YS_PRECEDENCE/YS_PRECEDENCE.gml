/// @description YuiScript operator precedence
enum YS_PRECEDENCE {
	// applies last
	DIRECTIVE =   1,
	
	LAMBDA =      2,
	CONDITIONAL = 3,
	LOGIC_OR =    4,
	LOGIC_AND =   5,
	COMPARISON =  6,
	EQUALITY =    7,
	SUM =         8,
	PRODUCT =     9,
	PREFIX =      10,
	CALL =        11, // also subscript (e.g. member access and indexing)
}