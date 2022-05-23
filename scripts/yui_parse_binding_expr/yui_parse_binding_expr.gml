/// @description parses a binding expression into a binding
function yui_parse_binding_expr(expr_source, resources, slot_values) {
	
	static token_def = new YsTokenDefinition();
	
	static parser = new YsParser(undefined, YS_TOKEN.EOF);
	
	if YUI_COMPILER_ENABLED {
		// need to get this by string in case it gets deleted from yui_compiled_functions.gml
		static getFunctionTable = asset_get_index("yui_get_function_table");
	
		static table = getFunctionTable ? getFunctionTable() : undefined;
	
		// check if the expression has been compiled
		if table {
			// TODO BUG
			// loading by source doesn't work for slots where the same $slot may resolvw
			// to different values in different template instances.
			// to fix this, we'd ned to recursively replace slot identifiers with
			// their slot values in order to get the unique source per use case.
			// This might be difficult to do correctly as it's posible that the number of
			// unique source expressions could be different for different runs depending
			// on how dynamically the UI is assembled
			
			var entry = table[? expr_source];
			if entry {
				var compiled_binding = new YuiCompiledBinding(entry.id, expr_source, entry);
				return compiled_binding;
			}
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