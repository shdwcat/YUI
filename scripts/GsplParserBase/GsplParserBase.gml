/// @description
function GsplParserBase(tokens, eof_token) constructor {
	self.tokens = tokens;
	self.eof_token = eof_token;
	
	current = 0;
	had_error = false;
	
	static consume = function(type, error_message) {
		if check(type) return advance();
		else {
			throw parser_error(peek(), error_message);
		}
	}
	
	static match = function(/* token type args */) { // ...
		var i = 0; repeat(argument_count) {
			var type = argument[i++];
			if check(type) {
				advance();
				return true;
			}
		}
		
		return false;
	}
	
	static check = function(token_type) {
		if isAtEnd() return false;
		return peek()._type == token_type;
	}
	
	static advance = function() {
		if !isAtEnd() current++;
		return previous();
	}
	
	static isAtEnd = function() {
		return peek()._type == eof_token;
	}
	
	static peek = function() {
		return tokens[current];
	}
	
	static previous = function() {
		return tokens[current - 1];
	}
	
	// === error handling ===	
	
	static parser_error = function(token, error_message) {
		if (token._type == eof_token) {
			_error(token._line, " at end - " + error_message);
		}
		else {
			_error(token._line, " at '" + token._lexeme + "' - " + error_message);
		}
		return new GsplParserError(token, error_message);
	}
	
	static _error = function(line, msg) {
		var text = "Error on line " + string(line) + ": " + msg;
		gspl_log(text);
	}
}