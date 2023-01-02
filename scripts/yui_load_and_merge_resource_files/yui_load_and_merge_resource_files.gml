/// @description load all resources from the provided filepaths into one merged resource map
function yui_load_and_merge_resource_files(filepaths, cabinet, base_folder) {
	var resource_map = {};
	
	// recursively load imported files
	var i = 0; repeat array_length(filepaths) {	
		var import_path = filepaths[i++];
		var import_resources = yui_load_resource_file(import_path, cabinet, base_folder);
			
		// copy import resources over the current resource_map
		var import_resource_names = variable_struct_get_names(import_resources);
		var j = 0; repeat array_length(import_resource_names) {
			var resource_name = import_resource_names[j++];
			resource_map[$resource_name] = import_resources[$resource_name];
		}
	}
	
	return resource_map;
}