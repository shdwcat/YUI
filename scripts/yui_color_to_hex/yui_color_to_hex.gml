/// @description
function yui_color_to_hex(color) {
	var dec = (color & 16711680) >> 16 | (color & 65280) | (color & 255) << 16;
	return yui_dec_to_hex(dec);
}
