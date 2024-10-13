/// @description here
function GsplPrattParserDefinition(eof_token) constructor {
	self.eof_token = eof_token;
	self.prefix_parselets = array_create(eof_token);
	self.infix_parselets = array_create(eof_token);
	
	// custom parsers should implement these 'standard' expression constructors
	// which are used by the core parselets like GsplLiteralParselet
	self.Literal = undefined;
	self.Identifier = undefined;
	self.PrefixOperator = undefined;
	self.BinaryOperator = undefined;
	self.Set = undefined;
	self.Conditional = undefined;
	self.Call = undefined;
	self.Subscript = undefined;
	self.Indexer = undefined;
	
	static prefix = function(token, parselet) {
		prefix_parselets[token] = parselet;
	}
	
	static prefixOperator = function(token, precedence) {
		prefix_parselets[token] = new GsplPrefixOperatorParselet(precedence);
	}
	
	static infix = function(token, parselet) {
		infix_parselets[token] = parselet;
	}
	
	static infixOperatorLeft = function(token, precedence) {
		infix_parselets[token] = new GsplBinaryOperatorParselet(precedence, false);
	}
	
	static infixOperatorRight = function(token, precedence) {
		infix_parselets[token] = new GsplBinaryOperatorParselet(precedence, true);
	}
}