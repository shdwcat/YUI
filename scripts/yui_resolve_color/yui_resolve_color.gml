/// @description here
function yui_resolve_color(color_value) {	
	
	static color_table = __yui_init_color_table();
	
	if is_string(color_value) {
		if string_char_at(color_value, 1) == "#" {
			return yui_color_from_hex_string(color_value);
		}
		else {
			var color = color_table[$ string_lower(color_value)];
			if color >= 0 {
				return color | $FF000000;
			}
			else {
				return color_value;
			}
		}
	}
	else {
		return color_value;
	}
}