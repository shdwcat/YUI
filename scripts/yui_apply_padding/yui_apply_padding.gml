///// @desc  returns a new rect with the padding applied to the draw rect and the size of the effective padding that was applied
///// @param {struct} draw_rect the available size
///// @param {struct} padding
///// @param {struct.YuiElementSize} size element size props
///// @param {struct} [bound_values]
//function yui_apply_padding(draw_rect, padding, size, bound_values = undefined) {
	
//	var max_w = draw_rect.w;
//	var max_h = draw_rect.h;
		
//	if size {		
//		max_w = min(draw_rect.w, size.max_w);
//		max_h = min(draw_rect.h, size.max_h);
		
//		if bound_values {
//			var width = bound_values.w;
//			var height = bound_values.h;
//		}
//		else {
//			var width = size.w;
//			var height = size.h;
//		}
		
//		if is_numeric(width) {			
//			if size.w_type == YUI_LENGTH_TYPE.Proportional {
//				max_w = width * max_w;
//			}
//			else {
//				max_w = width;
//			}
//		}
		
//		if is_numeric(height) {
//			if size.h_type == YUI_LENGTH_TYPE.Proportional {
//				max_h = height * max_h;
//			}
//			else {
//				max_h = height;
//			}
//		}
//	}
	
//	var padded_rect = {
//		x: draw_rect.x + padding.left,
//		y: draw_rect.y + padding.top,
//		w: max_w - padding.w,
//		h: max_h - padding.h,
//	};
	
//	return padded_rect;
//}