/// @description
function yui_read_placement_mode(mode_name) {
	static names_to_values = {
		top_left: YUI_PLACEMENT_MODE.TopLeft,
		top_center: YUI_PLACEMENT_MODE.TopCenter,
		top_right: YUI_PLACEMENT_MODE.TopRight,
		left_top: YUI_PLACEMENT_MODE.LeftTop,
		left_center: YUI_PLACEMENT_MODE.LeftCenter,
		left_bottom: YUI_PLACEMENT_MODE.LeftBottom,
		bottom_left: YUI_PLACEMENT_MODE.BottomLeft,
		bottom_center: YUI_PLACEMENT_MODE.BottomCenter,
		bottom_right: YUI_PLACEMENT_MODE.BottomRight,
		right_top: YUI_PLACEMENT_MODE.RightTop,
		right_center: YUI_PLACEMENT_MODE.RightCenter,
		right_bottom: YUI_PLACEMENT_MODE.RightBottom,
	}
	
	if is_string(mode_name) {
		return names_to_values[$ mode_name];
	}
	else {
		return mode_name;
	}
}

