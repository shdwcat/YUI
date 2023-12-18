/// @description
function YsSlotParselet() : GsplPrefixParselet() constructor {

	static parse = function(parser, token) {
		var path = token._lexeme;
		
		// given 'foo.bar.baz' get 'foo' and 'bar.baz'
		var path_parts = yui_string_split(path, ".", 2);
		var slot_key = path_parts[0];

		var slot_value = parser.slot_values.get(slot_key);
		
		var sub_path = array_length(path_parts) > 1
			? path_parts[1]
			: "";
		
		if yui_is_binding(slot_value) {
			if sub_path == "" {
				// if there's no sub path, return the binding itself
				return slot_value;
			}
			else {
				return new YuiNestedBinding(slot_value, sub_path);
			}
		}
		else if sub_path == "" {
			// if there is no sub path, return the value (wrapped)
			return new YuiValueWrapper(slot_value);
		}
		else {
			return new YuiValueBinding(slot_value, sub_path);
		}
	}
}