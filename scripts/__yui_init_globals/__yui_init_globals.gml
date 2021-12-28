// define all YUI globals
global.__yui_globals = {};

// converts placement string values from a yui_file to the enum equivalent
global.__yui_globals.placement_map = {
	top_left: placement_mode.TopLeft,
	top_center: placement_mode.TopCenter,
	top_right: placement_mode.TopRight,
	left_top: placement_mode.LeftTop,
	left_middle: placement_mode.LeftCenter,
	left_bottom: placement_mode.LeftBottom,
	bottom_left: placement_mode.BottomLeft,
	bottom_center: placement_mode.BottomCenter,
	bottom_right: placement_mode.BottomRight,
	right_top: placement_mode.RightTop,
	right_middle: placement_mode.RightCenter,
	right_bottom: placement_mode.RightBottom,	
};