/// @description some metadata about a token enum
function GsplTokenDefinition(eof_token, string_token, number_token, identifier_token) constructor {
	
	// can't pass a script name via base arguments so each must set this
	self.token_type = undefined;
	
	self.eof_token = eof_token;
	self.string_token = string_token;
	self.number_token = number_token;
	self.identifier_token = identifier_token;
	
	// map of keywords strings to keyword token type
	self.keywords = undefined;
}