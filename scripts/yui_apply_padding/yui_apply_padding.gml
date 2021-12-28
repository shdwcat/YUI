/// @description returns a new rect with the padding applied to the draw rect
/// and the size of the effective padding that was applied
function yui_apply_padding(draw_rect, padding, size) {
	
	var max_w = draw_rect.w;
	var max_h = draw_rect.h;
		
	if size {		
		max_w = min(draw_rect.w, size.max_w);
		max_h = min(draw_rect.h, size.max_h);
		
		if is_numeric(size.w) {
			max_w = size.w;
		}
		if is_numeric(size.h) {
			max_h = size.h;
		}
	}
	
	var padded_rect = {
		x: draw_rect.x + padding.left,
		y: draw_rect.y + padding.top,
		w: max_w - padding.w,
		h: max_h - padding.h,
	};
	
	return padded_rect;
}