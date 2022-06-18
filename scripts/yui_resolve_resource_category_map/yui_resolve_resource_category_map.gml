/// @description Finds all the resources with the given group name
function yui_resolve_resource_category_map(resource_group_name, resources) {
	
	var category_map = {};
	
	// loop over every resource in the resources struct and find the ones with
	// the provided resource group name
	var resource_names = variable_struct_get_names(resources);
	var resource_count = array_length(resource_names);
	
	var i = 0; repeat resource_count {
		
		// get the resource from the resource name for this index
		var resource_name = resource_names[i];
		var resource = variable_struct_get(resources, resource_name);
		
		// get the resource_group value for the resource, if any
		var item_group_name = yui_variable_struct_try_get(resource, "resource_group");
		
		// match against the provided resource_group_name
		if item_group_name == resource_group_name {
			var item_resource_key = yui_variable_struct_try_get(resource, "resource_key");
			variable_struct_set(category_map, item_resource_key, resource);
		}
		
		i++;
	}
	
	return category_map;
}