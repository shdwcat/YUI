/// @description parses a binding expression into a binding
function yui_parse_binding_expr(expr, resources, slot_values) {
	
	static token_def = new YsTokenDefinition();
	
	static parser = new YsParser(undefined, YS_TOKEN.EOF);
	
	// TODO: make scanner static
	var scanner = new YsScanner(expr, token_def);
	
	var tokens = scanner.scanTokens();
	
	// NOTE: will break if we ever recursively parse
	parser.source = expr;
	parser.tokens = tokens;
	parser.current = 0;
	var binding = parser.parse(resources, slot_values);
	
	return binding;
}