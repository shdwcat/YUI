/// @description resolves the imports of a yui_document with the declared resources
function yui_resolve_resource_imports(resources, imports, base_folder, cabinet) {
	
	// load and merge imports
	var merged_resources = yui_load_and_merge_resource_files(imports, cabinet, base_folder)
	
	if resources {
		// merge the document resources over the imported resources
		var document_resource_names = variable_struct_get_names(resources);
		var name_count = array_length(document_resource_names)
		var n = 0; repeat name_count {
			var name = document_resource_names[n];
		
			if variable_struct_exists(merged_resources, name)
			&& merged_resources[$name] != document_resource[$name] {
				yui_warning("Overwriting resource with name:", name);
			}
		
			var document_resource = variable_struct_get(resources, name);
			variable_struct_set(merged_resources, name, document_resource);
			
			n++;
		}
	}
		
	return merged_resources;
}