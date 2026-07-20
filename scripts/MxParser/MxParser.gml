/// @description defines the pratt parser for Mx expressions
function MxParser(tokens, source, parse_context, parser_definition = mx_parser_definition())
	: GsplPrattParser(tokens, parser_definition) constructor {
	self.source = source;
	
	parser_definition.initContext(parse_context);
	self.parse_context = parse_context;
	
	self.resources = parse_context.resources; // HACK
	
	// used by YuiLambda/YuiLambdaVariable to coordinate param/identifier resolution
	self.lambda_context = undefined;
	
	self.data_paths = {};
	
	self.traceExpr = function(expr) {
		var debug = expr.debug();
		var debug_text = SnapToYAML(debug, true);
		log(debug_text);
		clipboard_set_text(debug_text);
	}
	
	static trackDataPath = function(path) {
		if path == "" return;
			
		if struct_exists(data_paths, path) {
			data_paths[$ path] += 1;
		}
		else {
			data_paths[$ path] = 1;
		}
	}
	
	static markDataPathOptional = function(path) {
		if path == "" return;
		
		if struct_exists(data_paths, path) {
			data_paths[$ path] -= 1;
			if data_paths[$ path] == 0
				struct_remove(data_paths, path);
		}
	}
	
	// NOTE: could reduce struct creation by just having the list of paths with common prefixes removed
	static mergeDataPaths = function() {
		var paths = struct_get_names(data_paths);
		var count = array_length(paths);
		
		if count == 0
			return undefined;
		
		var result = {};
		var i = 0; repeat count {
			var path = paths[i++];
			mx_merge_data_type_path(result, path);
		}
		
		return result;
	}

	// === expression types ===	
	
	static parse = function() {
		
		var expr = parseExpression();
		
		if mx_is_binding(expr) {
			
			// store data type
			expr.data_type = mergeDataPaths();
			
			// store the source for debugging
			expr.source = source;
			if expr[$ "trace"] == true {
				DEBUG_BREAK_YUI
			}
		
			if !mx_is_live_binding(expr) {
				// unwrap top level wrappers
				expr = expr.resolve();
			}
		}
		
		return expr;
	}
}