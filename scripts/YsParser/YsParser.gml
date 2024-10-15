/// @description defines the pratt parser for YuiScript expressions
function YsParser(tokens, source, resources, slot_values) : GsplPrattParser(tokens, mx_parser_definition()) constructor {
	self.source = source;
	
	self.resources = resources;
	self.slot_values = slot_values;
	
	// used by YuiLambda/YuiLambdaVariable to coordinate param/identifier resolution
	self.context = {};

	// === expression types ===	
	
	static parse = function() {
		
		var expr = parseExpression();
		
		if yui_is_binding(expr) {
			
			// store the source for debugging
			expr.source = source;
			if expr[$ "trace"] == true {
				DEBUG_BREAK_YUI
			}
		
			if !yui_is_live_binding(expr) {
				// unwrap top level wrappers
				expr = expr.resolve();
			}
		}
		
		return expr;
	}
}