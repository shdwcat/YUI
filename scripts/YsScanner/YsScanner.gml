/// @description YuiScript scanner
function YsScanner(source, token_definition) : GsplScanner(source, token_definition) constructor {
	
	// implements scanning logic
	static scanToken = function() {
	    var c = advance();
		
	    switch (c) {
		    case "(": addToken(YS_TOKEN.LEFT_PAREN); break;
		    case ")": addToken(YS_TOKEN.RIGHT_PAREN); break;
		    case "[": addToken(YS_TOKEN.LEFT_BRACKET); break;
		    case "]": addToken(YS_TOKEN.RIGHT_BRACKET); break;
		    case ".":
				if isDigit(peek()) scanNumber();
				else addToken(YS_TOKEN.DOT);
				break;
		    case ",": addToken(YS_TOKEN.COMMA); break;
			case "?":
				if match("?") addToken(YS_TOKEN.QUESTION_QUESTION)
				else addToken(YS_TOKEN.QUESTION);
				break;
			case "|": addToken(YS_TOKEN.PIPE); break;
		    case "-": addToken(YS_TOKEN.MINUS); break;
		    case "+": addToken(YS_TOKEN.PLUS); break;
		    case "*": addToken(YS_TOKEN.STAR); break;
			case "!":
				addToken(match("=") ? YS_TOKEN.BANG_EQUAL : YS_TOKEN.BANG);
				break;
			case "=":
				if match("=") addToken(YS_TOKEN.EQUAL_EQUAL)
				else if match(">") addToken(YS_TOKEN.ARROW)
				else addToken(YS_TOKEN.EQUAL)
				break;
			case "<":
				addToken(match("=") ? YS_TOKEN.LESS_EQUAL : YS_TOKEN.LESS);
				break;
			case ">":
				if match(">") {
					addToken(YS_TOKEN.GREATER_GREATER);
					// TODO: match function identifier here?
				}
				else if match("=") addToken(YS_TOKEN.GREATER_EQUAL);
				else addToken(YS_TOKEN.GREATER);
				break;
			
			case " ": // space	
			case "	": // tab
				// Ignore whitespace.
				break;

			case "\r":
				_error(_line, "Unexpected carriage return in expression")
				break;
				
			case "\n":
				_line++;
				_error(_line, "Unexpected newline in expression")
				break;
				
			case "/":
				{
					if match("/") {
						// A comment goes until the end of the line.
						while peek() != chr(10) && !isAtEnd()
							advance();
					}
					else if match("*") {
						/* inline comments */
						while peek() != "*" && peekNext() != "/" && !isAtEnd() {
							if peek() == "\n" _line++;
							advance();
						}
					
						if isAtEnd() {
							_error(_line, "unterminated inline comment");
						}
						else {
							advance(); // consume *
							advance(); // consume /
						
							var comment = gspl_string_substring(_source, _start, _current);
						}
					}
					else {
						addToken(YS_TOKEN.SLASH);
					}
				}
				break;
			
			case "\"": scanString(); break;
			case "'": scanString("'"); break;
			case "`": scanString("`"); break;
			
			// identifiers
			case "@":
				if peek() == "@" {
					// if we get @@ we'll skip that and start parsing from the next character
					skip(1);
				}
				else {
					skip(1);
					scanVariablePath(YS_TOKEN.BINDING_IDENTIFIER);
				}
				break;
			case "$":
				if match("+") {
					addToken(YS_TOKEN.STRING_PLUS);
				}
				else {
					skip(1);
					scanVariablePath(YS_TOKEN.SLOT_IDENTIFIER);
				}
				break;
			case "&":
				skip(1);
				scanVariablePath(YS_TOKEN.RESOURCE_IDENTIFIER);
				break;
			
			case "#":
				scanColor(YS_TOKEN.COLOR); 
				break;
			
			default:
				if isDigit(c) scanNumber();
				else if isAlpha(c) {
					var identifier = matchIdentifierName();
					
					// check keywords first
					var token_type = keywords[$ identifier];
					if token_type {
						addToken(token_type);
					}
					else {
						// if it's not a keyword, it's an identifier
						addToken(YS_TOKEN.IDENTIFIER, identifier);
					}					
				}
				else _error(_line, "Unexpected character:", c);
				break;
		}
	}
	
	static scanVariablePath = function(identifier_type = undefined) {
		
		var identifier = matchVarPath();
		
		// check reserved keywords first
		var token_type = keywords[$ identifier];
		
		// if it's not a keyword then it's an identifier
		token_type ??= identifier_type ?? identifier_token;
		
		addToken(token_type);
	}
	
	static matchVarPath = function() {
		var matched = false;
		while isAlphaNumeric(prev()) || prev() == "." {
			advance();
			matched = true;
		}
		
		// need to backtrack one because the advance loop will have gone slightly too far
		_current--;
		
		var path = gspl_string_substring(_source, _start, _current);
		return path;
	}
}