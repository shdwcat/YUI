/// @description applies alignment to a drawn item within its draw_rect
function yui_align_item(item, alignment_h, alignment_v) {
	var xoffset = 0;
	var yoffset = 0;
	
	// todo: right + bottom + stretch
	switch alignment_h {
		case fa_right:
			xoffset = item.draw_rect.w - item.draw_size.w;
			break;
		case fa_center:
			xoffset = item.parent.draw_size.x - item.x - item.draw_size.w / 2;
			break;
	}
	
	switch alignment_v {
		case fa_bottom:
			yoffset = item.draw_rect.h - item.draw_size.h;
			break;
		case fa_middle:
			yoffset = (item.draw_rect.h - item.draw_size.h) / 2;
			break;
	}
	
	item.move(floor(xoffset), floor(yoffset));
}

// this is for aligning within the item's draw_rect
function yui_align_from_placement(item, placement) {
	switch placement {
		case YUI_PLACEMENT_MODE.TopLeft:
			yui_align_item(item, fa_left, fa_bottom);
			break;
		case YUI_PLACEMENT_MODE.TopCenter:
			yui_align_item(item, fa_center, fa_bottom);
			break;
		case YUI_PLACEMENT_MODE.TopRight:
			yui_align_item(item, fa_right, fa_bottom);
			break;
			
		case YUI_PLACEMENT_MODE.LeftTop:
			yui_align_item(item, fa_right, fa_top);
			break;
			
		case YUI_PLACEMENT_MODE.RightTop:
			yui_align_item(item, fa_left, fa_top);
			break;
		
		case YUI_PLACEMENT_MODE.BottomLeft:
			yui_align_item(item, fa_left, fa_top);
			break;
		case YUI_PLACEMENT_MODE.BottomCenter:
			yui_align_item(item, fa_center, fa_top);
			break;
		case YUI_PLACEMENT_MODE.BottomRight:
			yui_align_item(item, fa_right, fa_top);
			break;
	}
}