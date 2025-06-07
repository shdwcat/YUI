// this works around a broken compiler restriction
function gspl_wrap(v) { return v; }

/// @description
function GsplPrattParser(tokens, definition) : GsplParserBase(tokens, gspl_wrap(definition.eof_token)) constructor {
	self.definition = definition;
	
	self.Literal = definition.Literal;
	self.Identifier = definition.Identifier;
	self.PrefixOperator = definition.PrefixOperator;
	self.BinaryOperator = definition.BinaryOperator;
	self.Set = definition.Set;
	self.Conditional = definition.Conditional;
	self.Call = definition.Call;
	self.List = definition.List;
	self.Subscript = definition.Subscript;
	self.Indexer = definition.Indexer;
	
	static level = -1;
	
	static log = function(message) {
		yui_log_to_datafile("../logs/yui/parse.txt", string_repeat("\t", level) + message);
		yui_log(string_repeat("\t", level) + message);
	}

	static parseExpression = function(precedence = 0) {
		level++;
		var token = advance();
		var prefix = definition.prefix_parselets[token._type];
		
		if trace
			log($"precedence {precedence} > Got prefix token {token.getTokenName()}");
		
		if prefix == undefined throw yui_error("Could not parse token:", token._literal);
		
		var left_expr = prefix.parse(self, token, precedence);
		if is_struct(left_expr) && left_expr[$ "optimize"] != undefined {
			left_expr = left_expr.optimize();
		}
		
		while peek()._type != eof_token && precedence < getPrecedence() {

			token = advance();
			
			if trace
				log($"precedence {precedence} > Got infix token {token.getTokenName()}");
			
			var infix = definition.infix_parselets[token._type];
			left_expr = infix.parse(self, left_expr, token, precedence);
			if is_struct(left_expr) && left_expr[$ "optimize"] != undefined {
				left_expr = left_expr.optimize();
			}
		}
		
		if trace
			logExpressionClosure(precedence);
		
		level--;
		
		return left_expr;
	}
	
	static parseInfix = function(left_expr, precedence) {
		level++;
		
		while peek()._type != eof_token && precedence < getPrecedence() {

			var token = advance();
			
			var infix = definition.infix_parselets[token._type];
			left_expr = infix.parse(self, left_expr, token, precedence);
			if is_struct(left_expr) && left_expr[$ "optimize"] != undefined {
				left_expr = left_expr.optimize();
			}
		}
		
		if trace
			logExpressionClosure(precedence);
		
		level--;
		
		return left_expr;
	}
	
	static getPrecedence = function() {
		var infix = definition.infix_parselets[peek()._type];
		
		//if infix == 0 {
		//	gspl_log("unknown operator:", peek().getTokenName());
		//}
		
		return infix != 0
			? infix.precedence
			: 0;
	}
	
	static logExpressionClosure = function(precedence) {
			if peek()._type == eof_token
				log("finished expression at end of source");
			else {
				var nextPrec = getPrecedence();
				log($"finished expression because token {getInfixName()} has precedence {nextPrec} which is <= {precedence}");
			}
	}
	
	static getInfixName = function() {
		var infix = definition.infix_parselets[peek()._type];
		
		if infix == 0
			return $"{peek()._lexeme} ({peek().getTokenName()})"
		else
			return $"{peek()._lexeme} ({instanceof(infix)})";
	}
}