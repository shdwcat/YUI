/// @description parses a binding expression into a binding
function yui_parse_binding_expr(expr_source, resources, slot_values) {
	
	static token_def = new YsTokenDefinition();
	
	static parser = new YsParser(undefined, YS_TOKEN.EOF);
	
	// need to get this by string in case it gets deleted from yui_compiled_functions.gml
	static getFunctionTable = asset_get_index("yui_get_function_table");
	
	static table = getFunctionTable ? getFunctionTable() : undefined;
	
	// check if the expression has been compiled
	if table {
		var entry = table[? expr_source];
		if entry {
			var compiled_binding = new YuiCompiledBinding(entry.id, expr_source, entry);
			return compiled_binding;
		}
	}
	
	// TODO: make scanner static ??
	var scanner = new YsScanner(expr_source, token_def);
	
	var tokens = scanner.scanTokens();
		
	var old_tokens = parser.tokens;
	var old_expr = parser.source;
	var old_current = parser.current;
	
	parser.source = expr_source;
	parser.tokens = tokens;
	parser.current = 0;
	var binding = parser.parse(resources, slot_values);
	
	// compile the binding for future speed up
	if YUI_COMPILER_ENABLED && yui_is_binding(binding) {
		yui_compile_binding(binding, expr_source);
	}
	
	parser.tokens = old_tokens;
	parser.source = old_expr;
	parser.current = old_current;
	
	return binding;
}