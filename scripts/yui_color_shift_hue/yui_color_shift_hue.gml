/// @description changes the hue in the source color to match the hue color while maintaining source luminance
function yui_color_shift_hue(source_color, hue_color, lum_factor) {
	
	// calculate source luminance
	var r = color_get_red(source_color);
	var g = color_get_green(source_color);
	var b = color_get_blue(source_color);
	var lum
		= r/255 * .2126
		+ g/255 * .7152
		+ b/255 * .03928;
		
	// shift the hue of the original color
	var hue = color_get_hue(hue_color);
	var sat = color_get_saturation(hue_color);
	var val = color_get_value(source_color);	
	var shift_color = make_color_hsv(hue, sat, val) 
	
	// calculate new luminance
	var nr = color_get_red(shift_color);
	var ng = color_get_green(shift_color);
	var nb = color_get_blue(shift_color);
	var new_lum
		= nr/255 * .2126
		+ ng/255 * .7152
		+ nb/255 * .03928;
	
	// apply luminance factor to restore original luminance
	var factor = lum/new_lum * lum_factor;
	nr = min(nr * factor, 255);
	ng = min(ng * factor, 255);
	nb = min(nb * factor, 255);
	
	// make the final color
	var final_color = make_color_rgb(nr, ng, nb);
	var alpha_hex = source_color & 0xFF000000;
	
	return final_color | alpha_hex;
}