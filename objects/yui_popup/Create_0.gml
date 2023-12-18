/// @description init

// Inherit the parent event
event_inherited();

border_arrange = arrange;
arrange = function(available_size, viewport_size) {
	border_arrange(available_size, viewport_size);
	
	// align popup
	switch bound_values.placement {
		case YUI_PLACEMENT_MODE.TopLeft:
			yui_align_item(self, { h: fa_left, v: fa_bottom });
			break;
		case YUI_PLACEMENT_MODE.TopCenter:
			yui_align_item(self, { h: fa_center, v: fa_bottom });
			break;
		case YUI_PLACEMENT_MODE.TopRight:
			yui_align_item(self, { h: fa_right, v: fa_bottom });
			break;
			
		case YUI_PLACEMENT_MODE.LeftTop:
			yui_align_item(self, { h: fa_right, v: fa_top });
			break;
			
		case YUI_PLACEMENT_MODE.RightTop:
			yui_align_item(self, { h: fa_left, v: fa_top });
			break;
		
		case YUI_PLACEMENT_MODE.BottomRight:
			yui_align_item(self, { h: fa_right, v: fa_top });
			break;
	}	
}