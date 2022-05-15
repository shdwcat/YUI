/// @description calculates the viewport part when a rectangle does not fit within the viewport size
function yui_trim_rect_to_viewport(x, y, w, h, viewport_size) {
	var vR = viewport_size.x + viewport_size.w;
	var vB = viewport_size.y + viewport_size.h;
	var innerL = clamp(x, viewport_size.x, vR);
	var innerT = clamp(y, viewport_size.y, vB);
	var innerR = clamp(x + w, viewport_size.x, vR);
	var innerB = clamp(y + h, viewport_size.y, vB);
	var vw = innerR - innerL;
	var vh = innerB - innerT;
	
	var l = max(viewport_size.x - x, 0);
	var t = max(viewport_size.y - y, 0);
	
	return {
		l: l,
		t: t,
		w: vw,
		h: vh,
		x: innerL,
		y: innerT,
		x2: innerR,
		y2: innerB,
		visible: vw > 0 && vh > 0,
		clipped: vw < w || vh < h,
	};
}

