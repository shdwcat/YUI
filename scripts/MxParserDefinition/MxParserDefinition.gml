function mx_parser_definition() {
	static definition = new MxParserDefinition();	
	return definition;
}

function MxParserDefinition() : GsplPrattParserDefinition(YS_TOKEN.EOF) constructor {

	// feather disable GM2017
	self.Literal = YuiValueWrapper;
	self.Identifier = YuiIdentifier;
	self.PrefixOperator = YuiPrefixOperatorBinding;
	self.BinaryOperator = YuiOperatorBinding;
	self.Set = YuiSetValue;
	self.Conditional = YuiThenElseBinding;
	self.Call = YuiCallFunction;
	self.List = MxListExpression;
	self.Indexer = YuiIndexBinding;
	self.Subscript = YuiSubscript;
	// feather restore GM2017
		
	// === operators ===

	// prefix
	prefix(YS_TOKEN.STRING, new GsplLiteralParselet());
	prefix(YS_TOKEN.NUMBER, new GsplLiteralParselet());
	prefix(YS_TOKEN.COLOR, new GsplLiteralParselet());
	prefix(YS_TOKEN.TRUE, new GsplLiteralParselet());
	prefix(YS_TOKEN.FALSE, new GsplLiteralParselet());
	prefix(YS_TOKEN.UNDEFINED, new GsplLiteralParselet());
	
	prefix(YS_TOKEN.BINDING_IDENTIFIER, new YsBindingParselet());
	prefix(YS_TOKEN.SLOT_IDENTIFIER, new YsSlotParselet());
	prefix(YS_TOKEN.RESOURCE_IDENTIFIER, new YsResourceParselet());
	prefix(YS_TOKEN.HOST_IDENTIFIER, new MxHostParselet());
	prefix(YS_TOKEN.IDENTIFIER, new MxIdentifierParselet());
			
	prefix(YS_TOKEN.LEFT_PAREN, new GsplGroupParselet(YS_TOKEN.RIGHT_PAREN));
	
	// list expressions
	prefix(YS_TOKEN.LEFT_BRACKET, new GsplListParselet(YS_TOKEN.COMMA, YS_TOKEN.RIGHT_BRACKET));
	
	// prefix operators
	prefixOperator(YS_TOKEN.MINUS, YS_PRECEDENCE.PREFIX);
	prefixOperator(YS_TOKEN.NOT, YS_PRECEDENCE.PREFIX);
	
	// assignment
	infix(YS_TOKEN.EQUAL, new YsSetParselet(YS_PRECEDENCE.ASSIGNMENT));
	
	// conditional (supports then/else and ?:)
	infix(YS_TOKEN.THEN,
		new GsplConditionalParselet(YS_PRECEDENCE.CONDITIONAL, YS_TOKEN.ELSE));
		
	// lambda definition e.g. var => log(var)
	infix(YS_TOKEN.ARROW,
		new YsLambdaParselet(YS_PRECEDENCE.LAMBDA));
		
	// method call e.g. bar()
	infix(YS_TOKEN.LEFT_PAREN,
		new GsplCallParselet(YS_PRECEDENCE.CALL, YS_TOKEN.COMMA, YS_TOKEN.RIGHT_PAREN));
				
	// member access e.g. foo.bar
	infix(YS_TOKEN.DOT,
		new GsplSubscriptParselet(YS_PRECEDENCE.CALL, YS_TOKEN.IDENTIFIER, YS_TOKEN.STRING));
		
	// indexing e.g. map[key]
	infix(YS_TOKEN.LEFT_BRACKET,
		new GsplIndexerParselet(YS_PRECEDENCE.CALL, YS_TOKEN.RIGHT_BRACKET));
			
	// infix call e.g. @foo |> bar()
	infix(YS_TOKEN.PIPE_GREATER,
		new GsplInfixCallParselet(YS_PRECEDENCE.CALL));
		
	// optional application, e.g. foo?(bar) foo?[bar] (or any infix parselet!)
	infix(YS_TOKEN.QUESTION, new MxOptionalParselet(YS_PRECEDENCE.PREFIX));
		
	// breakpoint
	infix(YS_TOKEN.BANG, new GsplTraceParselet(YS_PRECEDENCE.PREFIX));
		
	// infix call e.g. @foo >> bar()
	// DEPRECATED
	infix(YS_TOKEN.GREATER_GREATER,
		new GsplInfixCallParselet(YS_PRECEDENCE.CALL));
	
	// directives e.g. trace, freeze, etc
	infix(YS_TOKEN.PIPE, new YsDirectiveParselet());
	
	// infix operators (left associative)
	infixOperatorLeft(YS_TOKEN.STRING_PLUS, YS_PRECEDENCE.STRING_OP);
	
	infixOperatorLeft(YS_TOKEN.PLUS, YS_PRECEDENCE.SUM);
	infixOperatorLeft(YS_TOKEN.MINUS, YS_PRECEDENCE.SUM);
	infixOperatorLeft(YS_TOKEN.STAR, YS_PRECEDENCE.PRODUCT);
	infixOperatorLeft(YS_TOKEN.SLASH, YS_PRECEDENCE.PRODUCT);
	
	infixOperatorLeft(YS_TOKEN.EQUAL_EQUAL, YS_PRECEDENCE.EQUALITY);
	infixOperatorLeft(YS_TOKEN.EQUALS, YS_PRECEDENCE.EQUALITY);
	infixOperatorLeft(YS_TOKEN.BANG_EQUAL, YS_PRECEDENCE.EQUALITY);
	
	infixOperatorLeft(YS_TOKEN.GREATER, YS_PRECEDENCE.COMPARISON);
	infixOperatorLeft(YS_TOKEN.GREATER_EQUAL, YS_PRECEDENCE.COMPARISON);
	infixOperatorLeft(YS_TOKEN.LESS, YS_PRECEDENCE.COMPARISON);
	infixOperatorLeft(YS_TOKEN.LESS_EQUAL, YS_PRECEDENCE.COMPARISON);
	
	infixOperatorLeft(YS_TOKEN.AND, YS_PRECEDENCE.LOGIC_AND);
	infixOperatorLeft(YS_TOKEN.OR, YS_PRECEDENCE.LOGIC_OR);
	
	infixOperatorLeft(YS_TOKEN.QUESTION_QUESTION, YS_PRECEDENCE.CONDITIONAL);
}