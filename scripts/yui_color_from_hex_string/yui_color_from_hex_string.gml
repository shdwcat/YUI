/// @description converts a hex string like "#FFFFFF" to the rgb color
function yui_color_from_hex_string(hex_string) {
	
	hex_string = yui_string_after(hex_string, "#")
	
	// validate char count
	var length = string_length(hex_string);
	if length != 6 && length != 8 {
		throw yui_error("expecting 6 or 8 digit color hex value");
	}
	
		
	var hex_value = int64(ptr(hex_string)); // ptr hacks
		
	if length == 6 {
		// handle color without alpha
		var red = hex_value >> 16;
		var green = (hex_value & 0xFF00) >> 8;
		var blue = hex_value & 0xFF;
		var color = make_color_rgb(red, green, blue);
			
		// set alpha to 1
		color |= 0xFF000000;
	}
	else {
		// handle color with alpha
		var red = hex_value >> 16;
		var green = (hex_value & 0xFF00) >> 8;
		var blue = hex_value & 0xFF;
		var color = make_color_rgb(red, green, blue);
			
		// set alpha
		var alpha = hex_value & 0xFF000000;
		color |= alpha;
	}
	
	return color;
}