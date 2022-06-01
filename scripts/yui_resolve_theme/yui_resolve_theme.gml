/// @description resolves the theme props to the struct if the value is the theme_id
function yui_resolve_theme(theme_name = "") {
	
	static themes = {
		"_default": new YuiTheme("default", {}),
	};
	
	var theme = variable_struct_get(themes, theme_name)
		?? themes._default;
		
	return theme.props;
}