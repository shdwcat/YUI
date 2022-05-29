/// @description resolves the theme props to the struct if the value is the theme_id
function yui_resolve_theme() {
	
	static themes = {
		"default": new YuiTheme("default", {}),
	};
	
	if is_string(props.theme) {
		theme = themes[$ props.theme].props;
	}
	else {
		theme = props.theme.props;
	}
}