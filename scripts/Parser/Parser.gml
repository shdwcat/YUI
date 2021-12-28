// set up sentinels
#macro gspl_null global.__gspl_null
#macro gspl_done global.__gspl_done
gspl_null = new Sentinel("null");
gspl_done = new Sentinel("done");

/// @description base Parser implementation
function Parser(tokens, eof_token, parse_tree_definition) constructor {
	self.tokens = tokens; // Token array
	self.eof_token = eof_token; // the token that signifies the end of the 'file'
	self.parse_tree_definition = parse_tree_definition; // the definition for the parse tree
	
	Expr = new ExpressionFactory(parse_tree_definition);
	
	current = 0;
	had_error = false;
	
	static parse = function() {
		try
		{
			var statements = [];
			while !isAtEnd() {
				var stmt = declaration();
				if stmt == undefined {
					had_error = true;
				}
				array_push(statements, stmt);
			}
			return statements;
		}
		catch (error) {
			log(error);
			debug_log("Parser exited with error:", error);
			had_error = true;
			return undefined;
		}
	}
	
	// === rules ===
	
	static declaration = function() {
		try {
			if match(GS_TOKEN.VAR) return varDeclaration();
			return statement();
		}
		catch (error) {
			if instanceof(error) == "ParserError" {
				synchronize();
				return undefined;
			}
			else
				throw error;
		}
	}
	
	static varDeclaration = function() {
		var name = consume(GS_TOKEN.IDENTIFIER, "Expect variable name.");
		
		var initializer = undefined;
		if match(GS_TOKEN.EQUAL) {
			initializer = expression();
		}
		
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after variable declariation.");
		return Expr.VarStatement({ name: name, initializer: initializer });
	}
		
	
	static statement = function() {
		if match(GS_TOKEN.IF) return ifStatement();
		if match(GS_TOKEN.FOR) return forStatement();
		if match(GS_TOKEN.ANIMATE) return animateStatement();
		if match(GS_TOKEN.EVENT) return eventStatement();
		if match(GS_TOKEN.BREAK) return breakStatement();
		if match(GS_TOKEN.PRINT) return printStatement();
		if match(GS_TOKEN.KEYFRAME) return keyframeStatement();
		if match(GS_TOKEN.DELAY) return delayStatement();
		if match(GS_TOKEN.FRAME) return frameStatement();
		if match(GS_TOKEN.LEFT_BRACE) return Expr.BlockStatement({ statements: block() });
		
		return expressionStatement();
	}
	
	static ifStatement = function() {
		// the parens don't actually seem necessary?
		
		//consume(GS_TOKEN.LEFT_PAREN. "Expect '(' after 'if'.");
		//var condition = expression();
		var condition = logicalOr(); // this way doesn't allow assignment as a condition
		//consume(GS_TOKEN.RIGHT_PAREN. "Expect ')' after if condition.");		
		
		var thenBranch = statement();
		var elseBranch = undefined;
		if match(GS_TOKEN.ELSE) {
			elseBranch = statement();
		}
		
		return Expr.IfStatement({ condition: condition, thenBranch: thenBranch, elseBranch: elseBranch });
	}
	
	static forStatement = function() {
		var producer = iteratorExpression();
		
		// optional statement (usually a block)
		var stmt = undefined;
		if !match(GS_TOKEN.SEMICOLON) {
			stmt = statement();
		}
		else {
			stmt = Expr.EmptyStatement({});
		}
		
		return Expr.ForStatement({ producer: producer, statement: stmt });
	}
	
	static iteratorExpression = function() {
		var source = undefined;
		if match(GS_TOKEN.EACH) {
			return eachExpression();
		}
		else if match(GS_TOKEN.EVERY) {
			return everyExpression(); // TODO
		}
		else {
			// TODO: should only be identifier/get/call
			source = expression();
			return Expr.Iterator({ source: source });
		}			
	}
	
	static eachExpression = function() {
		var itemName = consume(GS_TOKEN.IDENTIFIER, "Expect identifier after 'each'.");
		
		consume(GS_TOKEN.IN, "Expect 'in' after 'for each' identifier.");
		
		// TODO: should only be identifier/get/call
		var source = expression();
		var producer = Expr.Iterator({ source: source });
		
		return Expr.EachExpr({ itemName: itemName, producer: producer });
	}
	
	self.in_animate_block = false;
	static animateStatement = function() {
		checkNotInBlock("event", self.in_event_block);
		
		// desugar into a for statement with a `frame` after the normal statement;
		
		self.in_animate_block = true;
		var forStmt = forStatement();
		self.in_animate_block = false;
		
		forStmt.statement = Expr.BlockStatement({
			statements: [
				forStmt.statement,
				Expr.FrameStatement({}),
			]
		});
		return forStmt;
	}
	
	self.in_event_block = false;
	static eventStatement = function() {
		checkInBlock("animate", self.in_animate_block);
		
		if match(GS_TOKEN.DRAW, GS_TOKEN.DRAWGUI) {
			var event = previous();
			self.in_event_block = true;
			var stmt = statement();
			self.in_event_block = false;
			return Expr.EventStatement({ event: event, statement: stmt });
		}
		
		throw parser_error(peek(), "Expect event name after 'event'");
	}
	
	static breakStatement = function() {
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after 'break'.");
		return Expr.BreakStatement({});
	}
	
	static keyframeStatement = function() {
		checkNotInBlock("event", self.in_event_block);
		
		var span = timespan();
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after keyframe timespan.");
		return Expr.KeyframeStatement({ timespan: span });
	}
	
	static delayStatement = function() {
		checkNotInBlock("event", self.in_event_block);
		
		var span = timespan();
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after delay timespan.");
		return Expr.DelayStatement({ timespan: span });
	}
	
	static frameStatement = function() {
		checkNotInBlock("event", self.in_event_block);
		
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after 'frame'.");
		return Expr.FrameStatement({});
	}
	
	static timespan = function() {
		var value = undefined;
		var units = undefined;
		if match(GS_TOKEN.NUMBER)
		{
			value = Expr.Literal({ value: previous()._literal });
		}		
		else if match(GS_TOKEN.IDENTIFIER) {
			value = Expr.Variable({ name: previous() });
		}
		else {
			throw parser_error(peek(), "Expecting number or identifier after 'keyframe'.");
		}
		
		// this is a hack to avoid defining timespan unit tokens for the scanner
		if match(GS_TOKEN.IDENTIFIER) {
			units = previous();
		}
		else {
			throw parser_error(peek(), "Expecting timespan unit after timespan value.");
		}
		
		return Expr.Timespan({ value: value, units: units });
	}
	
	static printStatement = function() {
		var value = expression();
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after value.");
		return Expr.PrintStatement({ expression: value });
	}
	
	static block = function() {
		var statements = [];
		while !check(GS_TOKEN.RIGHT_BRACE) && !isAtEnd() {
			array_push(statements, declaration());
		}		
		consume(GS_TOKEN.RIGHT_BRACE, "Expect '}' after block.");
		return statements;
	}
		
	static expressionStatement = function() {
		var expr = expression();
		consume(GS_TOKEN.SEMICOLON, "Expect ';' after expression.");
		return Expr.ExpressionStatement({ expression: expr });
	}
	
	static expression = function() {
		return assignment();
	}
	
	static assignment = function() {
		var expr = logicalOr();
		
		var assignOperator = undefined;
		// TODO: switch statement? hook the 'inner' operator to the token when we scan it?
		if match(GS_TOKEN.PLUS_EQUAL) {
			assignOperator = previous();
			assignOperator._type = GS_TOKEN.PLUS;
		}
		if match(GS_TOKEN.MINUS_EQUAL) {
			assignOperator = previous();
			assignOperator._type = GS_TOKEN.MINUS;
		}
				
		if assignOperator != undefined || match(GS_TOKEN.EQUAL) {
			var equals = previous();
			var value = assignment();
			
			// desugar 'x += 1' into 'x = x + 1'
			if assignOperator != undefined {
				var binaryOp = Expr.Binary({ left: expr, operator: assignOperator, right: value });
				value = binaryOp;
			}
			
			if expr.type == "Variable" {
				var name = expr.name;
				return Expr.Assign({ name: name, value: value });
			}
			else if expr.type == "Get" {
				var name = expr.name;
				return Expr.Set({ object: expr.object, name: name, value: value });
			}
			else {
				_error(equals, "Invalid Assignment Target");
			}
		}
		
		return expr;
	}
	
	static logicalOr = function() {
		var expr = logicalAnd();
		
		while match(GS_TOKEN.OR) {
			var operator = previous();
			var right = logicalAnd();
			expr = Expr.Logical({ left: expr, operator: operator, right: right });
		}
		
		return expr;
	}
	
	static logicalAnd = function() {
		var expr = equality();
		
		while match(GS_TOKEN.AND) {
			var operator = previous();
			var right = equality();
			expr = Expr.Logical({ left: expr, operator: operator, right: right });
		}
		
		return expr;
	}
	
	static equality = function() {
		var expr = comparison();

		while match(GS_TOKEN.BANG_EQUAL, GS_TOKEN.EQUAL_EQUAL) {
			var operator = previous();
			var right = comparison();
			expr = Expr.Binary({ left: expr, operator: operator, right: right });
		}

		return expr;
	}
	
	static comparison = function() {
		var expr = range();
		
		while match(GS_TOKEN.GREATER, GS_TOKEN.GREATER_EQUAL, GS_TOKEN.LESS, GS_TOKEN.LESS_EQUAL) {
			var operator = previous();
			var right = term();
			expr = Expr.Binary({ left: expr, operator: operator, right: right });
		}
	
		return expr;
	}
	
	static range = function() {		
		var expr = term();
		
		// only match one .. (1..5..10 is not valid)
		if match(GS_TOKEN.DOT_DOT) {
			var operator = previous();
			var right = term();
			expr = Expr.Binary({ left: expr, operator: operator, right: right });
		}
		
		return expr;
	}
	
	static term = function() {
		var expr = factor();
		
		while match(GS_TOKEN.MINUS, GS_TOKEN.PLUS) {
			var operator = previous();
			var right = factor();
			expr = Expr.Binary({ left: expr, operator: operator, right: right });
		}
	
		return expr;
	}
	
	static factor = function() {
		var expr = unary();
		
		while match(GS_TOKEN.SLASH, GS_TOKEN.STAR) {
			var operator = previous();
			var right = factor();
			expr = Expr.Binary({ left: expr, operator: operator, right: right });
		}
	
		return expr;
	}
	
	static unary = function() {
		if match(GS_TOKEN.BANG, GS_TOKEN.MINUS) {
			var operator = previous();
			var right = unary();
			return Expr.Unary({ operator: operator, right: right });
		}
	
		return call();
	}
	
	static call = function() {
		var expr = primary();
		
		while (true) {
			if match(GS_TOKEN.LEFT_PAREN) {
				expr = finishCall(expr);
			}
			else if match(GS_TOKEN.DOT) {
				var name = consume(GS_TOKEN.IDENTIFIER, "Expect property name after '.'.");
				expr = Expr.Get({ object: expr, name: name });
			}
			else if match(GS_TOKEN.QUESTION_DOT) {
				var name = consume(GS_TOKEN.IDENTIFIER, "Expect property name after '?.'.");
				expr = Expr.TryGet({ object: expr, name: name });
			}
			else if match(GS_TOKEN.LEFT_BRACKET) {
				var index = expression();
				consume(GS_TOKEN.RIGHT_BRACKET, "Expect ']' after indexer");
				expr = Expr.Indexer({ object: expr, index: index });
			}
			else {
				break;
			}
		}
		
		return expr;
	}
	
	static finishCall = function(callee) {
		var arguments = [];
		if !check(GS_TOKEN.RIGHT_PAREN) {
			do {
				array_push(arguments, expression());
			}
			until !match(GS_TOKEN.COMMA);
		}
		
		paren = consume(GS_TOKEN.RIGHT_PAREN, "Expect ')' after arguments.");
		
		return Expr.Call({ callee: callee, paren: paren, args: arguments });
	}
	
	static primary = function() {
		var expr = terminal();
		if expr != undefined return expr;
		
		// array literal
		if match(GS_TOKEN.LEFT_BRACKET) {
			var values = [];
			while !check(GS_TOKEN.RIGHT_BRACKET) && !isAtEnd() {
				array_push(values, expression());
				
				// require comma after all but the last item
				if !check(GS_TOKEN.RIGHT_BRACKET) {
					consume(GS_TOKEN.COMMA, "Expect ',' after value in array literal.");
				}
			}			
			consume(GS_TOKEN.RIGHT_BRACKET, "Expect  ']' after array literal.");
			return Expr.ArrayLiteral({ values: values });
		}
		
		if match(GS_TOKEN.LEFT_PAREN) {
			var expr = expression();
			consume(GS_TOKEN.RIGHT_PAREN, "Expect  ')' after expression.");
			return Expr.Grouping({ expression: expr });
		}
		
		throw parser_error(peek(), "Expect expression.");
	}
	
	static terminal = function() {
		if match(GS_TOKEN.FALSE) return Expr.Literal({ value: false });
		if match(GS_TOKEN.TRUE) return Expr.Literal({ value: true });
		if match(GS_TOKEN.NULL) return Expr.Literal({ value: gspl_null });
				
		if match(GS_TOKEN.STRING)
		{
			return Expr.Literal({ value: previous()._literal });
		}
		
		// TODO: some way out of the duplicated timespan check?
		
		if match(GS_TOKEN.NUMBER)
		{
			var number = Expr.Literal({ value: previous()._literal });
			
			// check for timespan
			if match(GS_TOKEN.IDENTIFIER) {
				var units = previous();
				return Expr.Timespan({ value: number, units: units });
			}
			
			return number;
		}
		
		if match(GS_TOKEN.IDENTIFIER) {
			// TODO: we could look up asset and runtime functions here and create 
			// expressions with the resolved values instead of resolving them dynamically
			// need to pass GmlEnvironment to the parser
			var variable = Expr.Variable({ name: previous() });
			
			// check for timespan
			if match(GS_TOKEN.IDENTIFIER) {
				var units = previous();
				return Expr.Timespan({ value: variable, units: units });
			}
			
			return variable;
		}
	}
	
	// === parse helpers ===
	
	static checkInBlock = function(block_name, is_in_block) {
		if !is_in_block {
			throw parser_error(previous(), "Invalid outside '" + block_name + "' block.");			
		}
	}
	
	static checkNotInBlock = function(block_name, is_in_block) {
		if is_in_block {
			throw parser_error(previous(), "Invalid inside '" + block_name + "' block.");			
		}
	}
	
	static consume = function(type, error_message) {
		if check(type) return advance();
		else throw parser_error(peek(), error_message);		
	}
	
	static match = function(/* token type args */) { // ...
		var i = 0; repeat(argument_count) {
			var type = argument[i++];
			if check(type) {
				advance();
				return true;
			}
		}
		
		return false;
	}
	
	static check = function(token_type) {
		if isAtEnd() return false;
		return peek()._type == token_type;
	}
	
	static advance = function() {
		if !isAtEnd() current++;
		return previous();
	}
	
	static isAtEnd = function() {
		return peek()._type == eof_token;
	}
	
	static peek = function() {
		return tokens[current];
	}
	
	static previous = function() {
		return tokens[current - 1];
	}
	
	// === error handling ===	
	
	static parser_error = function(token, error_message) {
		if (token._type == eof_token) {
			_error(token._line, " at end - " + error_message);
		}
		else {
			_error(token._line, " at '" + token._lexeme + "' - " + error_message);
		}
		return new ParserError(token, error_message);
	}
	
	static _error = function(line, msg) {
		var text = string_concat("Error on line", line, ":", msg);
		error(text);
		debug.debug_output += text + "\n";
	}
	
	static synchronize = function() {
		advance();
		
		while !isAtEnd() {
			if previous()._type == GS_TOKEN.SEMICOLON return;
			
			switch peek()._type {
				//case GS_TOKEN.CLASS
				//case GS_TOKEN.FUNCTION
				case GS_TOKEN.IF:
				case GS_TOKEN.YIELD:
				case GS_TOKEN.RETURN:
				case GS_TOKEN.VAR:
				case GS_TOKEN.DO:
				case GS_TOKEN.FOR:
				case GS_TOKEN.PARALLEL:
				case GS_TOKEN.ANIMATE:
				case GS_TOKEN.DELAY:
				case GS_TOKEN.KEYFRAME:
				case GS_TOKEN.FRAME:
				case GS_TOKEN.WHEN:
				case GS_TOKEN.EMIT:
				case GS_TOKEN.PRINT:
					return;
			}
			
			advance();
		}
	}
}