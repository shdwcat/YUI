// feather ignore GM2017
/// @description calculates the viewport part when a rectangle does not fit within the viewport size
function yui_trim_rect_to_viewport(x, y, w, h, viewport_size) {
	var viewport_right = viewport_size.x + viewport_size.w;
	var viewport_bottom = viewport_size.y + viewport_size.h;
	
	var innerL = clamp(x, viewport_size.x, viewport_right);
	var innerT = clamp(y, viewport_size.y, viewport_bottom);
	var innerR = clamp(x + w, viewport_size.x, viewport_right);
	var innerB = clamp(y + h, viewport_size.y, viewport_bottom);
	
	var trimmed_width = innerR - innerL;
	var trimmed_height = innerB - innerT;
	
	var l = max(viewport_size.x - x, 0);
	var t = max(viewport_size.y - y, 0);
	
	if trace
		yui_break()
	
	return {
		l: l,
		t: t,
		w: trimmed_width,
		h: trimmed_height,
		x: innerL,
		y: innerT,
		x2: innerR,
		y2: innerB,
		visible: trimmed_width > 0 && trimmed_height > 0,
		clipped: trimmed_width < w || trimmed_height < h,
	};
}

