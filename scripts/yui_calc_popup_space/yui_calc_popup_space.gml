// calculates the space on screen where a popup could draw
function yui_calc_popup_space(placement, parent_size) {
	
	// TODO: any way to account for views?
	screen_w = window_get_width();
	screen_h = window_get_height();
	
	switch placement {
		// in e.g. TopLeft, the first part says which edge to position outside of
		// and the second one says which side of that space to align to
		// so TopLeft means outside of the top edge of the parent,
		// but aligned to the left edge of the parent
		
		case YUI_PLACEMENT_MODE.TopLeft:
			return {
				x: parent_size.x,
				w: screen_w - parent_size.x,
				y: 0,
				h: parent_size.y, // top of parent
			};
		case YUI_PLACEMENT_MODE.LeftTop:
			return {
				x: 0,
				w: parent_size.x,
				y: parent_size.y,
				h: screen_h - parent_size.y,
			};
			
		case YUI_PLACEMENT_MODE.TopRight:
			return {
				x: 0,
				w: parent_size.x + parent_size.w, // right edge of parent
				y: 0,
				h: parent_size.y, // top of parent
			};
		case YUI_PLACEMENT_MODE.RightTop:
			return {
				x: parent_size.x + parent_size.w, // right edge of parent
				w: screen_w - (parent_size.x + parent_size.w),
				y: parent_size.y,
				h: screen_h - parent_size.y,
			};
		
		case YUI_PLACEMENT_MODE.TopCenter:
			return {
				x: 0,
				w: screen_w,
				y: 0,
				h: parent_size.y, // top of parent
			};
			
		case YUI_PLACEMENT_MODE.BottomLeft:
			return {
				x: parent_size.x,
				w: screen_w - parent_size.x,
				y: parent_size.y + parent_size.h,
				h: screen_h - (parent_size.y + parent_size.h),
			};
		case YUI_PLACEMENT_MODE.BottomRight:
			return { 
				x: 0, 
				w: parent_size.x + parent_size.w,
				y: parent_size.y + parent_size.h,
				h: screen_h - (parent_size.y + parent_size.h),
			};
		default:
			return { x: parent_size.x, y: parent_size.y, w: screen_w, h: screen_h };
	}
}