Mx();

function Mx() {
	static Definition = new MxDefinition();
	
	static parse = function(value, resources, slot_values) {
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

function mx_merge_data_type_path(data_type, path) {
	if path == ""
		return;
	
	var parts = string_split(path, ".", , 2);
	
	var count = array_length(parts);
	if count == 0 return;
	
	var prefix = parts[0];
	if count == 1 {
		// if the prefix doesn't exist, add it as an empty key
		if !struct_exists(data_type, prefix) {
			data_type[$prefix] = undefined;
		}
		return;
	}
	
	var rest = parts[1];
	
	// if the prefix doesn't exist, add it as a a struct
	if !struct_exists(data_type, prefix) {
		data_type[$prefix] = {};
	}
	else {
		data_type[$prefix] ??= {};
	}
	
	// merge the rest of our path into the struct for the prefix
	mx_merge_data_type_path(data_type[$prefix], rest);	
}

function mx_merge_data_types(left, right) {
	if left == undefined
		return right;
	if right == undefined
		return left;
	
	var right_names = struct_get_names(right);
	var i = 0; repeat array_length(right_names) {
		var right_name = right_names[i++];
		var right_side = right[$ right_name];
		
		if struct_exists(left, right_name) {
			 var left_side = left[$ right_name];
			 mx_merge_data_types(left_side, right_side);
		}
		else {
			// if the right side doesn't exist in the left side, just add it
			left[$ right_name] = right_side;
		}
	}
	
	return left;
}

function mx_verify_data_type(name, data_type, value, prefix = "") {
	var data_fields = struct_get_names(data_type);
	var count = array_length(data_fields);
	
	if count == 0 return; // TODO verify no extra fields?
	
	if !is_struct(value)
		throw mx_error($"{name}: Expected struct value but got '{typeof(value)}'");
	
	var i = 0; repeat count {
		var field = data_fields[i++];
		if !struct_exists(value, field)
			throw mx_error($"{name}: expected value for field '{prefix}{field}'");
		
		// verify inner type if present
		var field_type = data_type[$ field];
		if field_type != undefined
			mx_verify_data_type(name, field_type, value[$ field], $"{prefix}{field}.");
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
#macro mx_error yui_error

#macro mx_bind yui_bind
#macro mx_bind_struct yui_bind_struct
#macro mx_bind_and_resolve yui_bind_and_resolve
#macro mx_bind_handler yui_bind_handler

#macro mx_is_binding yui_is_binding
#macro mx_is_binding_expr yui_is_binding_expr
#macro mx_is_call yui_is_call
#macro mx_is_lambda yui_is_lambda

#macro mx_resolve_binding yui_resolve_binding