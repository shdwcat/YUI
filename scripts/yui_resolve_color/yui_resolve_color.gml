/// @description here
function yui_resolve_color(color_value) {		
	if is_string(color_value) {
		if string_char_at(color_value, 1) == "$" {
			return yui_color_from_hex_string(color_value);
		}
		else {
			return asset_get_index("c_" + color_value);
		}
	}
	else {
		return color_value;
	}
}