/// @description
function GsplGroupParselet(group_end_token) constructor {
	
	self.group_end_token = group_end_token;
	
	static parse = function(parser, token) {
		var expr = parser.parseExpression();
		
		// TODO: token to char
		parser.consume(group_end_token, "Expecting ')' after group expression");
		
		return expr;
	}
    
}