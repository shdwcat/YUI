/// @description resolves the imports of a yui_document with the declared resources
function yui_resolve_resource_imports(resources, imports, base_folder, cabinet) {
	
	var merged_resources = {};
	
	// merge each resource
	var import_count = array_length(imports);
	var i = 0; repeat import_count {
		var import_item = imports[i]; 
		
		if string_char_at(import_item, 1) == "/" {
			// paths like '/Cards/foo.dcs' should resolve against the cabinet's root folder
			var resource_filepath = cabinet.folder_path + string_delete(import_item, 1, 1);
		}
		else {
			var resource_filepath = base_folder + "/" + import_item;
		}

		var resource_file = cabinet.file(resource_filepath);
		if resource_file == undefined {
			throw yui_error("File not found! " + resource_filepath);
		}
		
		// only load resource files
		if resource_file.file_type != "resources" {
			i++;
			continue;
		}
		
		var resource_data = resource_file.tryRead();
		
		var trace = resource_data[$ "trace"];
		if trace {
			DEBUG_BREAK_YUI
		}
		
		// get the inner resources from the imported resource file
		var resource_file_imports = resource_data[$ "import"];
		if resource_file_imports != undefined {
			
			// recursively resolve imports from the resource data
			var relative_folder = filename_dir(resource_filepath);
			
			var resource_file_resources = resource_data[$ "resources"] ?? {};
			
			var inner_resources = yui_resolve_resource_imports(
				resource_file_resources,
				resource_data.import,
				relative_folder,
				cabinet);
			yui_log("loaded file", resource_filepath)
		}
		else {
			var inner_resources = resource_data[$ "resources"] ?? {};
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