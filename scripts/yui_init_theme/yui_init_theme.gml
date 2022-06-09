/// @description loads a theme from the theme definition
function yui_init_theme(theme_definition, folder_path) {
	
	static default_props = {
		import: [],
		resources: {},
	};
	
	// fills in imports and resources if missing
	var props = yui_apply_props(theme_definition, default_props);

	// resolve resources
	var resources = yui_resolve_resource_imports(
		props.resources,
		props.import,
		folder_path);
		
	var slot_values = {};
		
	var bound_resources = yui_bind_struct(resources, resources, slot_values, true, true);
	
	// bind the theme struct recursively to resolve resource imports
	var theme = yui_bind_struct(props.theme, bound_resources, slot_values, , true);
	
	// allow the resources to be accessed directly
	theme.resources = bound_resources
	
	return theme;
}