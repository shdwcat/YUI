/// @description YuiScript operator precedence
enum YS_PRECEDENCE {
	// applies last
	DIRECTIVE =   1,
	
	CONDITIONAL = 2,
	LOGIC_OR =    3,
	LOGIC_AND =   4,
	COMPARISON =  5,
	EQUALITY =    6,
	SUM =         7,
	PRODUCT =     8,
	PREFIX =      9,
	CALL =        10,
}