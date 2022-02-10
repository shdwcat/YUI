/// @description YuiScript scanner
function YsScanner(source, token_definition) : GsplScanner(source, token_definition) constructor {
	
	// implements scanning logic
	scanToken = function() {
	    var c = advance();
		
	    switch (c) {
		    case "(": addToken(YS_TOKEN.LEFT_PAREN); break;
		    case ")": addToken(YS_TOKEN.RIGHT_PAREN); break;
		    case "[": addToken(YS_TOKEN.LEFT_BRACKET); break;
		    case "]": addToken(YS_TOKEN.RIGHT_BRACKET); break;
		    case ".": addToken(YS_TOKEN.DOT); break;
		    case ",": addToken(YS_TOKEN.COMMA); break;
			case "?": addToken(YS_TOKEN.QUESTION); break;
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
				else _error(_line, "expected '=' after '='");
				break;
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
				skip(1);
				scanVariablePath(YS_TOKEN.SLOT_IDENTIFIER);
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
					if peek() == "(" {
						// required until I can clean up YuiCallFunction to
						// be more sane about how it calls scripts/functions/methods
						addToken(YS_TOKEN.IDENTIFIER);
					}
					else {
						// check keywords first
						var token_type = keywords[$ identifier];
						if token_type {
							addToken(token_type);
						}
						else {
							// if it's not a keyword, allow simple strings without quotes
							addToken(YS_TOKEN.STRING, identifier);
						}
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
		if token_type == undefined {
			token_type = identifier_type ?? identifier_token;
		}
		
		addToken(token_type);
	}
	
	static matchVarPath = function() {
		var matched = false;
		while isAlphaNumeric(peek()) || peek() == "." {
			advance();
			matched = true;
		}
		
		if !matched {
			// if we didn't match any chars, backtrack and return empty path
			// (e.g. using @ by itself)
			_current--;
			return "";
		}
		
		var path = gspl_string_substring(_source, _start, _current);
		return path;
	}
}