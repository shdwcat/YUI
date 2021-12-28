/// @description GsplScanner for 'GScript'
function GsScanner(source, token_definition) 
	: GsplScanner(source, token_definition) constructor {
	
	scanToken = function() {
	    var c = advance();
		
	    switch (c) {
		    case "(": addToken(GS_TOKEN.LEFT_PAREN); break;
		    case ")": addToken(GS_TOKEN.RIGHT_PAREN); break;
			case "?":
				if match(".") addToken(GS_TOKEN.QUESTION_DOT);
				else _error(_line, "Unexpected character after '?':", c);
				break;
		    case ".":
				if match(".") addToken(GS_TOKEN.DOT_DOT);
				else addToken(GS_TOKEN.DOT);
				break;
		    case "{": addToken(GS_TOKEN.LEFT_BRACE); break;
		    case "}": addToken(GS_TOKEN.RIGHT_BRACE); break;
		    case "[": addToken(GS_TOKEN.LEFT_BRACKET); break;
		    case "]": addToken(GS_TOKEN.RIGHT_BRACKET); break;
		    case ",": addToken(GS_TOKEN.COMMA); break;
		    case "-": 
				if match("=") addToken(GS_TOKEN.MINUS_EQUAL);
				else addToken(GS_TOKEN.MINUS);
				break;
		    case "+": 
				if match("=") addToken(GS_TOKEN.PLUS_EQUAL);
				else addToken(GS_TOKEN.PLUS);
				break;
		    case ";": addToken(GS_TOKEN.SEMICOLON); break;
		    case "*": addToken(GS_TOKEN.STAR); break;
			
			case "!":
				addToken(match("=") ? GS_TOKEN.BANG_EQUAL : GS_TOKEN.BANG);
				break;
			case "=":
				var token = match("=") ? GS_TOKEN.EQUAL_EQUAL : GS_TOKEN.EQUAL;
				addToken(token);
				break;
			case "<":
				addToken(match("=") ? GS_TOKEN.LESS_EQUAL : GS_TOKEN.LESS);
				break;
			case ">":
				addToken(match("=") ? GS_TOKEN.GREATER_EQUAL : GS_TOKEN.GREATER);
				break;
			
			case "\r":
			case " ":			
			case "	": // tab
				// Ignore whitespace.
				break;

			//case chr(10):
			case "\n":
				_line++;
				break;
				
			case "/":
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
						
						var comment = string_substring(_source, _start, _current);
					}
				}
				else {
					addToken(GS_TOKEN.SLASH);
				}
				break;
				
			
			case "\"": scanString(); break;
			case "'": scanString("'"); break;
			
			default:
				if isDigit(c) scanNumber();
				else if isAlpha(c) scanIdentifier();
				else _error(_line, "Unexpected character:", c);
				break;
		}
	}
}