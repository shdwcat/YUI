/// @description here
function yui_resolve_color(color_value) {	
	
	static color_table = {
		white: c_white,
		aqua: c_aqua,
		red: c_red,
		green: c_green,
	};
	
	if is_string(color_value) {
		if string_char_at(color_value, 1) == "#" {
			return yui_color_from_hex_string(color_value);
		}
		else {
			var color = color_table[$ color_value];
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