
function MxDefinition(token_definition = undefined, parser_definition = undefined) constructor {		
	self.token_definition = token_definition ?? new MxTokenDefinition();
	self.parser_definition = parser_definition ?? new MxParserDefinition();
	
	struct_expressions = {};
	
	static parse = function(expr_source, parse_context) {
		if expr_source == undefined return undefined;
		
		// common case: parsing an expression string
		if mx_is_binding_expr(expr_source) {
			var scanner = new MxScanner(expr_source, token_definition);
	
			var tokens = scanner.scanTokens();
	
			var parser = new MxParser(tokens, expr_source, parse_context, parser_definition);
			var expr = parser.parse();
	
			return expr;
		}
		
		// allow for declaring structs that resolve to an expression
		// (struct_expressions can be populated when inheriting MxDefinition)
		var is_struct_expr = is_struct(expr_source)
			&& struct_exists(expr_source, "type")
			&& struct_exists(struct_expressions, expr_source.type);
		if is_struct_expr {
			var make = struct_expressions[$ expr_source.type];
			return new make(expr_source, parse_context);
		}
		
		return expr_source;
	}
}
