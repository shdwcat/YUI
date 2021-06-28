/// @description resolves a transform function from the transform name
function yui_resolve_transform(transform_name, resources) {
	
	// try to get the transform by name from the current resources
	var transform_props = variable_struct_get(resources, transform_name);
	
	// if we didn't find the transform in resources, try to find a simple function with that name
	if is_undefined(transform_props) {
		// TODO: potential conflict if a resource has the name as a function and we want the function instead!			
		if asset_get_type(transform_name) == asset_script {		
			return asset_get_index(transform_name);
		}
		else {
			throw "could not find a resource or function named " + transform_name + ", this is an error!";
		}
	}
	
	// if did exist in resources, than the transform type tells us the function name
	else {
		var type_function = yui_get_script_by_name(transform_props.type);
		return {
			transform_function: type_function,
			transform_props: transform_props,
		}
	}
}