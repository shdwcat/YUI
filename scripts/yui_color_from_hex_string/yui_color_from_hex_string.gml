/// @description converts a hex string like "#FFFFFF" to the rgb color
function yui_color_from_hex_string(hex_color) {
	var red = string_copy(hex_color, 2, 2);
	var green = string_copy(hex_color, 4, 2);
	var blue = string_copy(hex_color, 6, 2);
	return make_color_rgb(yui_hex_to_dec(red), yui_hex_to_dec(green), yui_hex_to_dec(blue));
}