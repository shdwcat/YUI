/// @description init

// Inherit the parent event
event_inherited();

// popups block mouse events from propagating to elemennts below them
is_cursor_layer = true;

border_arrange = arrange;
arrange = function(available_size) {
	border_arrange(available_size);
	
	// align popup
	switch bound_values.placement {
		case placement_mode.TopLeft:
		case "top_left":
			yui_align_item(self, { h: fa_left, v: fa_bottom });
			break;
		case placement_mode.TopCenter:
		case "top_center":
			yui_align_item(self, { h: fa_center, v: fa_bottom });
			break;
		case placement_mode.TopRight:
		case "top_right":
			yui_align_item(self, { h: fa_right, v: fa_bottom });
			break;
			
		case placement_mode.LeftTop:
		case "left_top":
			yui_align_item(self, { h: fa_right, v: fa_top });
			break;
			
		case placement_mode.RightTop:
		case "right_top":
			yui_align_item(self, { h: fa_left, v: fa_top });
			break;
		
		case placement_mode.BottomRight:
		case "bottom_right":
			yui_align_item(self, { h: fa_right, v: fa_top });
			break;
	}	
}