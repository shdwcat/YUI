/// @description here
function MxSlotParselet() : GsplPrefixParselet() constructor {
	
	static initContext = function(parse_context) {
		// add a map from slot keys to the sub expressions that reference them
		parse_context.slot_expr_map = {};
	}

	static parse = function(parser, token) {
		var path = token._lexeme;
		
		// given 'foo.bar.baz' get 'foo' and 'bar.baz'
		var path_parts = string_split(path, ".", , 1);
		var slot_key = path_parts[0];
				
		var slot_values = parser.parse_context.slot_values;
		if slot_values == undefined
			throw yui_error("YsSlotParselet: parser does not have any slot_values");

		try {
			var slot_value = slot_values.get(slot_key);
		}
		catch (error) {
			error = yui_error(error.message + " in expression: " + parser.source);
			throw error;
		}
		
		var sub_path = array_length(path_parts) > 1
			? path_parts[1]
			: "";
		
		// if the slot value is an expression parse that also
		// NOTE: this can happen when setting the default value of a slot to an expression
		// as those are not parsed when the template/component is initialized
		if yui_is_binding_expr(slot_value) {
			slot_value = YUI.Ys.parse(slot_value, parser.parse_context)
		}
		
		
		if yui_is_binding(slot_value) {
			if sub_path == "" {
				// if there's no sub path, the result is the binding itself
				var result = slot_value;
			}
			else {
				var result = new YuiNestedBinding(slot_value, sub_path);
			}
		}
		else if sub_path == "" {
			// if there is no sub path, return the value (wrapped)
			var result = new YuiValueWrapper(slot_value);
		}
		else {
			var result = new YuiValueBinding(slot_value, sub_path);
		}
		
		// track the slot usage in the parse context
		var slot_expr_map = parser.parse_context.slot_expr_map;		
		var slot_expr_list = slot_expr_map[$ slot_key];
		
		if slot_expr_list == undefined {
			slot_expr_map[$ slot_key] = [result];
		}
		else {
			array_push(slot_expr_list, result);
		}
		
		return result;
	}
}