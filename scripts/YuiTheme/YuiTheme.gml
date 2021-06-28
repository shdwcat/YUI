/// @description defines a theme for a YUI render tree
/// This means things like fonts, colors, and BG images to use for panels, buttons
function YuiTheme(_theme_id, _props) constructor {
	static default_props = {
		text_styles: {
			title: { font: fnt_yui_title, color: c_white },
			subtitle: { font: fnt_yui_subtitle, color: c_white },
			body: { font: fnt_yui_body, color: c_white },
		},
		panel: {
			bg_sprite: yui_panel_bg,
			padding: 30,
			spacing: 5,
		},
		button: {
			bg_sprite: yui_button_bg,
			padding: [10, 5],
		},
		tooltip: {
			bg_color: yui_color_from_hex_string("#08334C"),
			border_color: yui_color_from_hex_string("#278ED1"),
			border_thickness: 1,
			padding: 5,
		},
		popup: {
			bg_color: yui_color_from_hex_string("#06162A"),
			border_color: yui_color_from_hex_string("#2183C0"),
			border_thickness: 1.5,
			padding: 5,
		},
	}
	
	theme_id = _theme_id;
	props = init_props_old(_props);
	
	// register theme
	YuiGlobals.themes[? theme_id] = self;
}