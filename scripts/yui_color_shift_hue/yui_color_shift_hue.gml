
function yui_color_shift_hue(source_color, hue_color, luma_factor = 1) {
	
	var alpha_hex = source_color & 0xFF000000;
	var source_luma = yui_color_get_luma(source_color);
	var target_luma = source_luma * luma_factor;
	var shift_color = yui_color_set_luma(hue_color, target_luma);
	
	// debug code
	//var shift_luma = yui_color_get_luma(shift_color);
	//var s = yui_color_to_hex(source_color);
	//var h = yui_color_to_hex(hue_color);
	
	return shift_color | alpha_hex;
}


// old code archived in case it becomes relevant somehow

//function yui_color_shift_hue(source_color, hue_color, luma_factor = 1) {
	//// calculate source luminance
	//var r = color_get_red(source_color);
	//var g = color_get_green(source_color);
	//var b = color_get_blue(source_color);
	//var lum
	//	= r/255 * yui_r_component
	//	+ g/255 * yui_g_component
	//	+ b/255 * yui_b_component;
		
	//// shift the hue of the original color
	//var hue = color_get_hue(hue_color);
	
	//if hue = 0 return source_color;
	
	//var sat = color_get_saturation(hue_color);
	//var val = color_get_value(source_color);
	//var shift_color = make_color_hsv(hue, sat, val) 
	
	//// calculate new luminance
	//var nr = color_get_red(shift_color);
	//var ng = color_get_green(shift_color);
	//var nb = color_get_blue(shift_color);
	//var new_lum
	//	= nr/255 * yui_r_component
	//	+ ng/255 * yui_g_component
	//	+ nb/255 * yui_b_component;
	
	//// apply luminance factor to restore original luminance
	//var factor = lum/new_lum * lum_factor;
	//var fr = clamp(nr * factor, 0, 255);
	//var fg = clamp(ng * factor, 0, 255);
	//var fb = clamp(nb * factor, 0,255);
	
	//// make the final color
	//var final_color = make_color_rgb(fr, fg, fb);
	//var alpha_hex = source_color & 0xFF000000;
	
	//var final_val = color_get_value(final_color);
	
	//return final_color | alpha_hex;
//}

/// @description changes the hue in the source color to match the hue color while maintaining source luminance
//function jjyui_color_shift_hue(source_color, hue_color, lum_factor = 1) {
//	var alpha_hex = source_color & 0xFF000000;
	
//	var r = color_get_red(source_color);
//	var g = color_get_green(source_color);
//	var b = color_get_blue(source_color);
//	var source = yui_rgb_to_yuv(r, g, b);
	
//	var hr = color_get_red(hue_color);
//	var hg = color_get_green(hue_color);
//	var hb = color_get_blue(hue_color);
//	var hue = yui_rgb_to_yuv(hr, hg, hb);
	
//	var s = color_to_hex(source_color);
//	var h = color_to_hex(hue_color);
	
//	var final_color = yui_make_color_yuv(source.y, hue.u, hue.v);
	
//	var final = yui_rgb_to_yuv(color_get_red(final_color), color_get_green(final_color), color_get_blue(final_color))
	
//	var f = color_to_hex(final_color);
	
//	return final_color | alpha_hex;
//}

