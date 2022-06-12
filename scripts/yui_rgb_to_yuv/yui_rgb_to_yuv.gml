// see https://www.shadertoy.com/view/3lycWz

// hdtv
//#macro yui_r_component .2126
//#macro yui_g_component .7152
//#macro yui_b_component .0722
// sdtv
#macro yui_r_component .299
#macro yui_g_component .587
#macro yui_b_component .114

function yui_rgb_to_yuv(r, g, b) {
	r /= 255;
	g /= 255;
	b /= 255;
	
	var lum
		= r * yui_r_component
		+ g * yui_g_component
		+ b * yui_b_component;
		
	return {
		y: lum,
		u: 0.493 * (b - lum),
		v: 0.877 * (r - lum),
	};
}