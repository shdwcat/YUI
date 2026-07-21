// feather ignore GM2017
/// @description calculates the viewport part when a rectangle does not fit within the viewport size
function yui_trim_rect_to_viewport(x, y, w, h, viewport_size) {
	var viewport_right = viewport_size.x + viewport_size.w;
	var viewport_bottom = viewport_size.y + viewport_size.h;
	
	// clamp the bounds of the rect within the viewport
	var innerL = clamp(x, viewport_size.x, viewport_right);
	var innerT = clamp(y, viewport_size.y, viewport_bottom);
	var innerR = clamp(x + w, viewport_size.x, viewport_right);
	var innerB = clamp(y + h, viewport_size.y, viewport_bottom);
	
	var viewport_width = innerR - innerL;
	var viewport_height = innerB - innerT;
	
	var left = max(viewport_size.x - x, 0);
	var top = max(viewport_size.y - y, 0);
	
	return {
		l: left,
		t: top,
		w: viewport_width,
		h: viewport_height,
		x: innerL,
		y: innerT,
		x2: innerR,
		y2: innerB,
		visible: viewport_width > 0 && viewport_height > 0,
		clipped: viewport_width < w || viewport_height < h,
	};
}