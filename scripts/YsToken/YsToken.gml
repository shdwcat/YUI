/// @description
function YsToken(type, lexeme, literal, line)
	: GsplToken(type, lexeme, literal, line) constructor {

	static getTokenName = get_yscript_token_name;
}

function get_yscript_token_name(token_type = undefined) {
	
	static type_map = make_yscript_type_map();
	
	token_type ??= _type;
	
	var name = type_map[token_type];
	return name == undefined
		? "no name defined for token type: " + string(token_type)
		: name;		
}

function make_yscript_type_map() {
	var type_map = array_create(YS_TOKEN.EOF + 1);
	type_map[YS_TOKEN.LEFT_PAREN] = "LEFT_PAREN";
	type_map[YS_TOKEN.RIGHT_PAREN] = "RIGHT_PAREN";
	type_map[YS_TOKEN.LEFT_BRACKET] = "LEFT_BRACKET";
	type_map[YS_TOKEN.RIGHT_BRACKET] = "RIGHT_BRACKET";
	type_map[YS_TOKEN.DOT] = "DOT";
	type_map[YS_TOKEN.COMMA] = "COMMA";
	type_map[YS_TOKEN.GREATER_GREATER] = "GREATER_GREATER";
	type_map[YS_TOKEN.QUESTION] = "QUESTION";
	type_map[YS_TOKEN.QUESTION_QUESTION] = "QUESTION_QUESTION";
	type_map[YS_TOKEN.COLON] = "COLON";
	type_map[YS_TOKEN.PIPE] = "PIPE";
		
	type_map[YS_TOKEN.MINUS] = "MINUS";
	type_map[YS_TOKEN.PLUS] = "PLUS";
	type_map[YS_TOKEN.SLASH] = "SLASH";
	type_map[YS_TOKEN.STAR] = "STAR";
		
	type_map[YS_TOKEN.BANG] = "BANG";
	type_map[YS_TOKEN.BANG_EQUAL] = "BANG_EQUAL";
	type_map[YS_TOKEN.EQUAL_EQUAL] = "EQUAL_EQUAL";
	type_map[YS_TOKEN.EQUALS] = "EQUALS";
	
	type_map[YS_TOKEN.GREATER_EQUAL] = "GREATER_EQUAL";
	type_map[YS_TOKEN.GREATER] = "GREATER";
	type_map[YS_TOKEN.LESS_EQUAL] = "LESS_EQUAL";
	type_map[YS_TOKEN.LESS] = "LESS";
	
	type_map[YS_TOKEN.NOT] = "NOT";
	type_map[YS_TOKEN.AND] = "AND";
	type_map[YS_TOKEN.OR] = "OR";
	type_map[YS_TOKEN.THEN] = "THEN";
	type_map[YS_TOKEN.ELSE] = "ELSE";
		
	type_map[YS_TOKEN.BINDING_IDENTIFIER] = "BINDING_IDENTIFIER";
	type_map[YS_TOKEN.SLOT_IDENTIFIER] = "SLOT_IDENTIFIER";
	type_map[YS_TOKEN.RESOURCE_IDENTIFIER] = "RESOURCE_IDENTIFIER";
	type_map[YS_TOKEN.IDENTIFIER] = "IDENTIFIER";
	
	type_map[YS_TOKEN.STRING] = "STRING";
	type_map[YS_TOKEN.NUMBER] = "NUMBER";
	type_map[YS_TOKEN.COLOR] = "COLOR";
	
	type_map[YS_TOKEN.TRUE] = "TRUE";
	type_map[YS_TOKEN.FALSE] = "FALSE";
	type_map[YS_TOKEN.UNDEFINED] = "UNDEFINED";
	
	type_map[YS_TOKEN.EOF] = "EOF";
	return type_map;
}