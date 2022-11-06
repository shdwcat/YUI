/// @description loads a theme from the theme definition
function yui_init_theme(theme_definition, name, folder_path) {
	
	static default_props = {
		import: [],
		constants: {},
		functions: {},
		resources: {},
	};
	
	// fills in imports and resources if missing
	var props = yui_apply_props(theme_definition, default_props);

	// resolve resources
	var resources = yui_resolve_resource_imports(
		props.resources,
		props.import,
		folder_path,
		YuiGlobals.yui_cabinet);
		
	var slot_values = {};
	
	// bind functions
	// TODO we could avoid this if using snap field order so that values would be resolved in order
	var functions = yui_bind_struct(props.functions, props.constants, slot_values, false, true);
	
	// merge constants and functions into resources
	var merged_resources = yui_apply_props(props.constants, functions, resources);
	
	// bind and resolve resources
	var bound_resources = yui_bind_struct(merged_resources, merged_resources, slot_values, true, true);
	
	// bind the theme struct recursively to resolve resource constants
	var theme = yui_bind_struct(props.theme, bound_resources, slot_values, false, true);
	
	theme.name = name;
	
	// allow the resources to be accessed directly
	theme.resources = bound_resources
	
	return theme;
}