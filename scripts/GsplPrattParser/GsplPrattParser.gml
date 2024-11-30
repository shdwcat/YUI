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

	static parseExpression = function(precedence = 0) {
		var token = advance();
		var prefix = definition.prefix_parselets[token._type];
		
		if prefix == undefined throw yui_error("Could not parse token:", token._literal);
		
		var left_expr = prefix.parse(self, token);
		if is_struct(left_expr) && left_expr[$ "optimize"] != undefined {
			left_expr = left_expr.optimize();
		}
		
		while peek()._type != eof_token && precedence < getPrecedence() {

			token = advance();
			
			var infix = definition.infix_parselets[token._type];
			left_expr = infix.parse(self, left_expr, token);
			if is_struct(left_expr) && left_expr[$ "optimize"] != undefined {
				left_expr = left_expr.optimize();
			}
		}
		
		return left_expr;
	}
	
	static getPrecedence = function() {
		var infix = definition.infix_parselets[peek()._type];
		
		if infix == 0 {
			//gspl_log("unknown operator:", peek().getTokenName());
		}
		
		return infix != 0
			? infix.precedence
			: 0;
	}
}