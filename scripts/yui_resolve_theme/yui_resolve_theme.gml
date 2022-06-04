/// @description resolves the theme props to the struct if the value is the theme_id
function yui_resolve_theme(theme_name = "default") {
	
	var theme_file = YuiGlobals.themes[$ theme_name];
	
	if theme_file == undefined {
		throw yui_error("Unable to find theme with name: " + theme_name);
	}
	
	var theme_data = theme_file.tryRead();
	
	return theme_data.theme;
}