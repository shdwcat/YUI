/// @description GsplScanner base
function GsplScanner(source, token_definition) constructor {

	_source = source; // string - TODO buffer?
	_length = string_length(source);
	
	self.token_definition = token_definition;
	self.TokenType = token_definition.token_type;
	self.keywords = token_definition.keywords;
	
	_eof = token_definition.eof_token;
	self.string_token = token_definition.string_token;
	self.number_token = token_definition.number_token;
	self.identifier_token = token_definition.identifier_token;
	
	_tokens = [];
	
	// NOTE: GMS strings use 1-based indexing!
	_start = 1;
	_current = 1;
	
	_line = 1;
	
	static scanTokens = function() {
		while !isAtEnd() {
			_start = _current;
			scanToken();
		}
		
		array_push(_tokens, new TokenType(_eof, "", undefined, _line));
		return _tokens;
	}
	
	// @func override this in a derived scanners
	static scanToken = function() {
		throw "Must override scanToken() from GsplScanner";
	}
	
	static isAtEnd = function() {
		return _current > _length;
	}
	
	static advance = function() {
		return string_char_at(_source, _current++);
	}
	
	static skip = function(count) {
		_start += count;
		_current += count;
	}
	
	static match = function(expected) {
		if isAtEnd() return false;
	    if string_char_at(_source, _current) != expected return false;

	    _current++;
	    return true;
	}
	
	static peek = function() {
		if isAtEnd() return chr(0);
		return string_char_at(_source, _current);
	}
		
	static peekNext = function() {
		if _current + 1 > _length return chr(0);
		return string_char_at(_source, _current + 1);
	}
	
	static addToken = function(type, literal = undefined) {
		var text = gspl_string_substring(_source, _start, _current);
		array_push(_tokens, new TokenType(type, text, literal, _line));
	}
	
	static isDigit = function(char) {
		var code = ord(char);
		return code >= ord("0") && code <= ord("9");
	}
	
	static isAlpha = function(char) {
		var code = ord(char);
		return (code >= ord("a") && code <= ord("z"))
			|| (code >= ord("A") && code <= ord("Z"))
			|| char == "_";
	}
	
	static isHexDigit = function(char) {
		var code = ord(char);
		return code >= ord("0") && code <= ord("9")
			|| (code >= ord("a") && code <= ord("f"))
			|| (code >= ord("A") && code <= ord("F"))
	}
	
	static isAlphaNumeric = function(char)
	{
		return isAlpha(char) || isDigit(char);
	}
	
	static scanString = function(terminator = "\"") {
		while peek() != terminator && !isAtEnd() {
			if peek() == "\n" _line++;
			advance();
		}
		
		if isAtEnd() {
			_error(_line, "unterminated string");
		}
		
		advance(); // the closing "
		
		var value = gspl_string_substring(_source, _start + 1, _current - 1);
		addToken(string_token, value);
	}
	
	static scanNumber = function() {
		while isDigit(peek()) advance();
		
		// look for decimal .
		if peek() == "." && isDigit(peekNext()) {
			
			advance(); // consume .
			
			while isDigit(peek()) advance();
		}
		
		var lexeme = gspl_string_substring(_source, _start, _current);
		var value = real(lexeme);
		addToken(number_token, value);
	}
	
	static matchIdentifierName = function() {
		while isAlphaNumeric(peek()) advance();
		
		var identifier = gspl_string_substring(_source, _start, _current);
		return identifier;
	}
	
	static scanIdentifier = function(identifier_type = undefined) {
		
		var identifier = matchIdentifierName();
		
		// check reserved keywords first
		var token_type = keywords[$ identifier];
		
		// if it's not a keyword then it's an identifier
		if token_type == undefined {
			token_type = identifier_type ?? identifier_token;
		}
		
		addToken(token_type);
	}
	
	static matchHexString = function(offset = 0) {
		while isHexDigit(peek()) advance();
		return gspl_string_substring(_source, _start + offset, _current);
	}
	
	static scanColor = function(color_token_type) {
		var hex_string = matchHexString(1 /* offset past # */);
		
		// validate char count
		var length = string_length(hex_string);
		if length != 6 && length != 8 {
			_error(_line, "expecting 6 or 8 digit color hex value");
		}
		
		var hex_value = int64(ptr(hex_string)); // ptr hacks
		
		if length == 6 {
			// handle color without alpha
			var red = hex_value >> 16;
			var green = (hex_value & 0xFF00) >> 8;
			var blue = hex_value & 0xFF;
			var color = make_color_rgb(red, green, blue);
			
			// set alpha to 1
			color |= 0xFF000000;
		}
		else {
			// handle color with alpha
			var red = hex_value >> 16;
			var green = (hex_value & 0xFF00) >> 8;
			var blue = hex_value & 0xFF;
			var color = make_color_rgb(red, green, blue);
			
			// set alpha
			var alpha = hex_value & 0xFF000000;
			color |= alpha;
		}
		
		addToken(color_token_type, color)
	}
	
	static _error = function(line, msg, value = undefined) {
		if value == undefined value = ""
		gspl_log("[", line, "]", msg, value);
	}
}