
// enable 4x anti-aliasing
display_reset(4, false);

// hack to deal with 4K
if display_get_height() > 2000 {
	var wx = window_get_x();
	var wy = window_get_y();
	window_set_position(wx - 683, wy - 384);
	window_set_size(2732, 1536);
	
	YUI();
	YUI.setViewConfig(new YuiViewConfig(2.0, "4k"));
}

if yui_check_scribble() {
	yui_log("Found scribble!");
	scribble_font_set_default(font_get_name(fnt_yui_body));
}