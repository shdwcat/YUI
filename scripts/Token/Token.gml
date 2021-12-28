/// @description token base constructor
function Token(type, lexeme, literal, line) constructor {
	
	if type == undefined {
		throw "type must be defined";
	}
	
	_type = type; // token enum (e.g. GS_TOKEN)
	_lexeme = lexeme; // string
	_literal = literal; // any
	_line = line; // int
	
	// override this to get the string name for a token type
	static getTokenName = function(token_type) {
		return "unnamed token: " + string(token_type);
	}
	
	static toString = function() {
		var literal = _literal == undefined ? "" : string(_literal);
		var type_name = getTokenName(_type);
		return type_name + " \"" + _lexeme + "\" " + literal;
	}

}