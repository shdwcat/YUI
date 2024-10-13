/// @description defines the pratt parser for YuiScript expressions
function YsParser(tokens, source) : GsplPrattParser(tokens, mx_parser_definition()) constructor {
	self.source = source;
	
	self.resources = undefined;
	self.slot_values = undefined;
	self.context = undefined;
	self.level = 0;

	// === expression types ===	
	
	static parse = function(resources, slot_values) {
		
		var old_resources = self.resources;
		var old_slot_values = self.slot_values;
		var old_context = self.context;
				
		// setting this context is annoying but *shrug*
		self.resources = resources;
		self.slot_values = slot_values;
		self.context = {};
		self.level++;
		
		var expr = parseExpression();
		
		// store the source for debugging
		expr.source = source;
		
		if expr[$ "trace"] == true {
			DEBUG_BREAK_YUI
		}
		
		if !expr.is_yui_live_binding {
			// unwrap top level wrappers
			expr = expr.resolve();
		}
		
		self.level--;
		self.context = old_context;
		self.slot_values = old_slot_values;
		self.resources = old_resources;
		
		return expr;
	}
}