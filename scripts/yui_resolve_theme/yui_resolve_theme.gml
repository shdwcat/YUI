/// @description resolves the theme props to the struct if the value is the theme_id
function yui_resolve_theme() {	
	if is_string(props.theme) {
		theme = YuiGlobals.themes[? props.theme].props;
	}
	else {
		theme = props.theme.props;
	}
}