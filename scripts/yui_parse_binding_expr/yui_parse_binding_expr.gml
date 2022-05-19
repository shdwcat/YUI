/// @description parses a binding expression into a binding
function yui_parse_binding_expr(expr, resources, slot_values) {
	
	static token_def = new YsTokenDefinition();
	
	static parser = new YsParser(undefined, YS_TOKEN.EOF);
	
	// TODO: make scanner static
	var scanner = new YsScanner(expr, token_def);
	
	var tokens = scanner.scanTokens();
		
	var old_tokens = parser.tokens;
	var old_expr = parser.source;
	var old_current = parser.current;
	
	parser.source = expr;
	parser.tokens = tokens;
	parser.current = 0;
	var binding = parser.parse(resources, slot_values);
	
	parser.tokens = old_tokens;
	parser.source = old_expr;
	parser.current = old_current;
	
	return binding;
}