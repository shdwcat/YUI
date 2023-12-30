
// enable 4x anti-aliasing
display_reset(4, false);

if yui_check_scribble() {
	yui_log("Found scribble!");
	scribble_font_set_default(font_get_name(fnt_yui_body));
}