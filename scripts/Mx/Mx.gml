Mx();

function Mx() {
	static Definition = new MxDefinition();
	
	static parse = function(value, resouces, slot_values) {
		return Definition.parse(value, resources, slot_values);
	}
}

function MxDefinition() constructor {		
	token_definition = new YsTokenDefinition();
	parser_definition = new MxParserDefinition();
	
	struct_expressions = {};
	
	static parse = function(value, resources, slot_values) {
		if value == undefined return undefined;
		
		// common case: parsing an expression string
		if mx_is_binding_expr(value) {
			return parseSource(value, resources, slot_values);
		}
		
		// allow for declaring structs that resolve to an expression
		// (struct_expressions can be populated when inheriting MxDefinition)
		var is_struct_expr = is_struct(value)
			&& struct_exists(value, "type")
			&& struct_exists(struct_expressions, value.type);
		if is_struct_expr {
			var make = struct_expressions[$ value.type];
			return new make(value, resources, slot_values);
		}
		
		return value;
	}
	
	static parseSource = function(expr_source, resources, slot_values) {
		var scanner = new YsScanner(expr_source, token_definition);
	
		var tokens = scanner.scanTokens();
	
		var parser = new YsParser(tokens, expr_source, resources, slot_values, parser_definition);
		var expr = parser.parse();
	
		return expr;
	}
}

// these work around compiler inadequacies

function mx_token_definition() {
	return Mx.Definition.token_definition;
}

function mx_parser_definition() {
	return Mx.Definition.parser_definition;
}

// macros to transition to mx_ instead of yui_ for expressions
#macro mx_break yui_break

#macro mx_bind yui_bind
#macro mx_bind_struct yui_bind_struct
#macro mx_bind_and_resolve yui_bind_and_resolve
#macro mx_bind_handler yui_bind_handler

#macro mx_is_binding yui_is_binding
#macro mx_is_binding_expr yui_is_binding_expr
#macro mx_is_call yui_is_call
#macro mx_is_lambda yui_is_lambda

#macro mx_resolve_binding yui_resolve_binding