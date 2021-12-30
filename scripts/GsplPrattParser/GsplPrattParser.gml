/// @description
function GsplPrattParser(tokens, eof_token) : GsplParserBase(tokens, eof_token) constructor {
	
	// see http://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/
	
	self.prefix_parselets = array_create(eof_token);
	self.infix_parselets = array_create(eof_token);
	
	// custom parsers should implement any of these for 'standard' infix parselets used in the parser
	self.Literal = undefined;
	self.Identifier = undefined;
	self.PrefixOperator = undefined;
	self.BinaryOperator = undefined;
	self.Indexer = undefined;
	self.Conditional = undefined;
	self.Call = undefined;

	static parseExpression = function(precedence = 0) {
		var token = advance();
		var prefix = prefix_parselets[token._type];
		
		if prefix == undefined throw new yui_error("Could not parse token:", token._literal);
		
		var left_expr = prefix.parse(self, token);
		
		while peek()._type != eof_token && precedence < getPrecedence() {

			token = advance();
			
			var infix = infix_parselets[token._type];
			left_expr = infix.parse(self, left_expr, token);
		}
		
		return left_expr;
	}
	
	static getPrecedence = function() {
		var infix = infix_parselets[peek()._type];
		
		if infix == 0 {
			gspl_log("unknown operator:", peek().getTokenName());
		}
		
		return infix != 0
			? infix.precedence
			: 0;
	}
	
	static prefix = function(token, parselet) {
		self.prefix_parselets[token] = parselet;
	}
	
	static prefixOperator = function(token, precedence) {
		self.prefix_parselets[token] = new GsplPrefixOperatorParselet(precedence);
	}
	
	static infix = function(token, parselet) {
		self.infix_parselets[token] = parselet;
	}
	
	static infixOperatorLeft = function(token, precedence) {
		self.infix_parselets[token] = new GsplBinaryOperatorParselet(precedence, false);
	}
	
	static infixOperatorRight = function(token, precedence) {
		self.infix_parselets[token] = new GsplBinaryOperatorParselet(precedence, true);
	}
}