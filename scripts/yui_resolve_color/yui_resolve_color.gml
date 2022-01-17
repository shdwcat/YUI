/// @description here
function yui_resolve_color(color_value) {	
	
	static color_table = {
		white: c_white,
		aqua: c_aqua,
		red: c_red,
		green: c_green,
		gray: c_gray,
		lightgray: 0xD3D3D3,
		darkgray: 0xA9A9A9,
		grey: c_gray,
		lightgrey: 0xD3D3D3,
		darkgrey: 0xA9A9A9,
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