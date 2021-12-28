/// @description runtime error information
function RuntimeError(token, message) constructor {
	self.token = token;
	self.message = message;
	
	static toString = function() {
		return "'" + token._lexeme + "' " + message;
	}
}