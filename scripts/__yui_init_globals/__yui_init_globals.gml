#macro YUI_VERSION "0.5.0"

yui_log("Welcome to YUI by @shdwcat - version " + YUI_VERSION);

// define all YUI globals
global.__yui_globals = {};

// converts placement string values from a yui_file to the enum equivalent
// TODO: switch to YuiStringHashMap
global.__yui_globals.placement_map = {
	top_left: YUI_PLACEMENT_MODE.TopLeft,
	top_center: YUI_PLACEMENT_MODE.TopCenter,
	top_right: YUI_PLACEMENT_MODE.TopRight,
	left_top: YUI_PLACEMENT_MODE.LeftTop,
	left_middle: YUI_PLACEMENT_MODE.LeftCenter,
	left_bottom: YUI_PLACEMENT_MODE.LeftBottom,
	bottom_left: YUI_PLACEMENT_MODE.BottomLeft,
	bottom_center: YUI_PLACEMENT_MODE.BottomCenter,
	bottom_right: YUI_PLACEMENT_MODE.BottomRight,
	right_top: YUI_PLACEMENT_MODE.RightTop,
	right_middle: YUI_PLACEMENT_MODE.RightCenter,
	right_bottom: YUI_PLACEMENT_MODE.RightBottom,
};

// color constants available in yui files
global.__yui_globals.color_table = {
	white: c_white,
	black: c_black,
	
	red: c_red,
	green: c_green,
	blue: c_blue,
	yellow: c_yellow,
	
	aqua: c_aqua,
	cyan: c_aqua,
	maroon: c_maroon,
	
	gray: c_gray,
	lightgray: 0xD3D3D3,
	darkgray: 0xA9A9A9,
	grey: c_gray,
	lightgrey: 0xD3D3D3,
	darkgrey: 0xA9A9A9,
};