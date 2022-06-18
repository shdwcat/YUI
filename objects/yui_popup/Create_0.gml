/// @description init

// Inherit the parent event
event_inherited();

// popups block mouse events from propagating to elemennts below them
is_cursor_layer = true;

border_arrange = arrange;
arrange = function(available_size, viewport_size) {
	border_arrange(available_size, viewport_size);
	
	// align popup
	switch bound_values.placement {
		case YUI_PLACEMENT_MODE.TopLeft:
		case "top_left":
			yui_align_item(self, { h: fa_left, v: fa_bottom });
			break;
		case YUI_PLACEMENT_MODE.TopCenter:
		case "top_center":
			yui_align_item(self, { h: fa_center, v: fa_bottom });
			break;
		case YUI_PLACEMENT_MODE.TopRight:
		case "top_right":
			yui_align_item(self, { h: fa_right, v: fa_bottom });
			break;
			
		case YUI_PLACEMENT_MODE.LeftTop:
		case "left_top":
			yui_align_item(self, { h: fa_right, v: fa_top });
			break;
			
		case YUI_PLACEMENT_MODE.RightTop:
		case "right_top":
			yui_align_item(self, { h: fa_left, v: fa_top });
			break;
		
		case YUI_PLACEMENT_MODE.BottomRight:
		case "bottom_right":
			yui_align_item(self, { h: fa_right, v: fa_top });
			break;
	}	
}