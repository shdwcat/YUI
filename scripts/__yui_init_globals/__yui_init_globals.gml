// define all YUI globals
global.__yui_globals = {};

// configures data specific to this project
global.__yui_globals.project_config = {
	yui_data_folder: "YUI\\",
}

// configures live debugging features
global.__yui_globals.debug_config = {
	project_data_folder: "D:\\Projects\\Game Design\\YUI\\datafiles\\",
}

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

// scribble set up
var fnt_dialogue = fnt_yui_body;
scribble_font_add_all();
scribble_font_set_default(font_get_name(fnt_dialogue));