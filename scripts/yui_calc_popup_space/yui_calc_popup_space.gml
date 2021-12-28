// calculates the space on screen where a popup could draw
function yui_calc_popup_space(popup_item) {
	var parent_size = popup_item.parent.draw_size;
	
	// TODO: any way to account for views?
	screen_w = window_get_width();
	screen_h = window_get_height();
	
	var placement = popup_item.bound_values.placement;
	switch popup_item.bound_values.placement {
		// in e.g. TopLeft, the first part says which edge to position outside of
		// and the second one says which side of that space to align to
		// so TopLeft means outside of the top edge of the parent,
		// but aligned to the left edge of the parent
		
		case placement_mode.TopLeft:
		case "top_left":
			return {
				x: parent_size.x,
				w: screen_w - parent_size.x,
				y: 0,
				h: parent_size.y
			};
		case placement_mode.LeftTop:
		case "left_top":
			return {
				x: 0,
				w: parent_size.x,
				y: parent_size.y,
				h: screen_h - parent_size.y
			};
			
		case placement_mode.RightTop:
		case "right_top":
			return {
				x: parent_size.x + parent_size.w, // right edge of parent
				w: screen_w - (parent_size.x + parent_size.w),
				y: parent_size.y,
				h: screen_h - parent_size.y
			};
			
		case placement_mode.BottomLeft:
		case "bottom_left":
			return {
				x: parent_size.x,
				w: screen_w - parent_size.x,
				y: parent_size.y + parent_size.h,
				h: screen_h - (parent_size.y + parent_size.h)
			};
		case placement_mode.BottomRight:
		case "bottom_right":
			return { 
				x: 0, 
				w: parent_size.x + parent_size.w,
				y: parent_size.y + parent_size.h,
				h: screen_h - (parent_size.y + parent_size.h)
			};
		default:
			return { x: parent_size.x, y: parent_size.y, w: screen_w, h: screen_h };
	}
}