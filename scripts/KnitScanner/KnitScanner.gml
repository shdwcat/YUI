/// @description GsplScanner for 'Knit'
function KnitScanner(source, token_definition) 
	: GsplScanner(source, token_definition) constructor {
	
	static scanToken = function() {
	    var c = advance();
		
	    switch (c) {
		    case "(": addToken(KNIT_TOKEN.LEFT_PAREN); break;
		    case ")": addToken(KNIT_TOKEN.RIGHT_PAREN); break;
			case "?":
				if match(".") addToken(KNIT_TOKEN.QUESTION_DOT);
				else _error(_line, "Unexpected character after '?':", c);
				break;
		    case ".":
				if match(".") addToken(KNIT_TOKEN.DOT_DOT);
				else addToken(KNIT_TOKEN.DOT);
				break;
		    case "{": addToken(KNIT_TOKEN.LEFT_BRACE); break;
		    case "}": addToken(KNIT_TOKEN.RIGHT_BRACE); break;
		    case "[": addToken(KNIT_TOKEN.LEFT_BRACKET); break;
		    case "]": addToken(KNIT_TOKEN.RIGHT_BRACKET); break;
		    case ",": addToken(KNIT_TOKEN.COMMA); break;
		    case "-": 
				if match("=") addToken(KNIT_TOKEN.MINUS_EQUAL);
				else addToken(KNIT_TOKEN.MINUS);
				break;
		    case "+": 
				if match("=") addToken(KNIT_TOKEN.PLUS_EQUAL);
				else addToken(KNIT_TOKEN.PLUS);
				break;
		    case ";": addToken(KNIT_TOKEN.SEMICOLON); break;
		    case "*": addToken(KNIT_TOKEN.STAR); break;
			
			case "!":
				addToken(match("=") ? KNIT_TOKEN.BANG_EQUAL : KNIT_TOKEN.BANG);
				break;
			case "=":
				var token = match("=") ? KNIT_TOKEN.EQUAL_EQUAL : KNIT_TOKEN.EQUAL;
				addToken(token);
				break;
			case "<":
				addToken(match("=") ? KNIT_TOKEN.LESS_EQUAL : KNIT_TOKEN.LESS);
				break;
			case ">":
				addToken(match("=") ? KNIT_TOKEN.GREATER_EQUAL : KNIT_TOKEN.GREATER);
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
						
						var comment = gspl_string_substring(_source, _start, _current);
					}
				}
				else {
					addToken(KNIT_TOKEN.SLASH);
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