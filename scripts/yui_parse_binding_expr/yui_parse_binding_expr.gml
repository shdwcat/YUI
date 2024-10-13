/// @description parses a binding expression into a binding
function yui_parse_binding_expr(expr_source, resources, slot_values) {
	
	if YUI_COMPILER_ENABLED {
		// need to get this by string in case it gets deleted from yui_compiled_functions.gml
		static getFunctionTable = asset_get_index("yui_get_function_table");
	
		static table = getFunctionTable ? getFunctionTable() : undefined;
	
		// check if the expression has been compiled
		if table {
			// TODO BUG
			// loading by source doesn't work for slots where the same $slot may resolve
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
	var scanner = new YsScanner(expr_source);
	
	var tokens = scanner.scanTokens();
	
	var parser = new YsParser(tokens, expr_source, resources, slot_values);
	var binding = parser.parse();
	
	// compile the binding for future speed up
	if YUI_COMPILER_ENABLED && yui_is_binding(binding) {
		yui_compile_binding(binding, expr_source);
	}
	
	return binding;
}