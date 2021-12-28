/// @description resolves the imports of a yui_document with the declared resources
function yui_resolve_resource_imports(resources, imports, yui_folder) {
	
	var merged_resources = {};
	
	// merge each resource
	var import_count = array_length(imports);
	var i = 0; repeat import_count {
		var import_item = imports[i]; 
		var resource_filepath = yui_folder + "/" + import_item;
					
		var exists = file_exists(resource_filepath);
		if !exists {
			throw "File not found! " + resource_filepath;
		}
		
		// don't try to load non-yui files (might be an interaction or such)
		var tokens = yui_string_split(import_item, ".");
		var last_token = tokens[array_length(tokens) - 1];
		if last_token != "yui" {
			continue;
		}
		
		// load the text
		var resource_file_text = string_from_file(resource_filepath);
		
		// TODO: cache this per file somehow so that we don't need to re-read files multiple times
		var resource_data = snap_from_yui(resource_file_text);
		
		var trace = resource_data[$ "trace"];
		if trace {
			var f = "f";
		}
		
		// get the inner resources from the imported resource file
		var resource_file_imports = resource_data[$ "import"];
		if resource_file_imports != undefined {
			
			// recursively resolve imports from the resource data
			var relative_folder = filename_dir(resource_filepath);
			
			var resource_file_resources = resource_data[$ "resources"];
			if resource_file_resources == undefined {
				resource_file_resources = {};
			}
			
			var inner_resources = yui_resolve_resource_imports(resource_file_resources, resource_data.import, relative_folder);
			yui_log("loaded file", resource_filepath)
		}
		else {
			var inner_resources = resource_data[$ "resources"];
			if inner_resources == undefined inner_resources = {};
		}
		
		// copy each named resource from resource_data.resources over merged_resources
		var inner_resource_names = variable_struct_get_names(inner_resources);
		var name_count = array_length(inner_resource_names)
		var n = 0; repeat name_count {
			var name = inner_resource_names[n];
			var inner_resource = inner_resources[$ name];
			merged_resources[$ name] = inner_resource;
			
			n++;
		}
		
		i++;
	}
	
	// merge the document resources over the imported resources
	var document_resource_names = variable_struct_get_names(resources);
	var name_count = array_length(document_resource_names)
	var n = 0; repeat name_count {
		var name = document_resource_names[n];
		var document_resource = variable_struct_get(resources, name);
		variable_struct_set(merged_resources, name, document_resource);
			
		n++;
	}
		
	return merged_resources;
}