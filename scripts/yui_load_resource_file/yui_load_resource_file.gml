/// @description loads a resource file/folder/path list into a single merged resource map
function yui_load_resource_file(filepath, cabinet, base_folder) {
	
	if string_char_at(filepath, 1) == "/" {
		// paths like '/Cards/foo.dcs' should resolve against the cabinet's root folder
		var resource_filepath = cabinet.folder_path + string_delete(filepath, 1, 1);
	}
	else {
		var resource_filepath = base_folder + "/" + filepath;
	}
	
	// if the filepath ends with a /, import the whole folder instead
	if string_ends_with(resource_filepath, "/") {
		// get the list of files in the folder
		var filepaths = gumshoe(resource_filepath, cabinet.extension, false);
		var i = 0; repeat array_length(filepaths) {
			filepaths[i] = string_delete(yui_string_after(filepaths[i], resource_filepath), 1, 1);
			i++;
		}
		
		var new_base_folder = string_delete(resource_filepath, string_length(resource_filepath), 1);
		return yui_load_and_merge_resource_files(filepaths, cabinet, new_base_folder);
	}
	
	// get the file
	var resource_file = cabinet.file(resource_filepath);
	if resource_file == undefined {
		throw yui_error("could not find file at:", resource_filepath);
	}
	
	// only load resource files
	// TODO: add widget file type support?
	if resource_file.file_type != "resources" {
		return {};
	}
	
	// load the data
	var resource_data = resource_file.tryRead();
	
	// resolve imports
	var imports = resource_data[$ "import"];
	if imports != undefined {
			
		// imports resolve relative to the current file
		var relative_folder = filename_dir(resource_filepath);
			
		var resource_map = yui_load_and_merge_resource_files(imports, cabinet, relative_folder);
	}
	else {
		var resource_map = {};
	}
	
	// copy the file's own resources over any imported resources
	var file_resources = resource_data[$ "resources"];
	if file_resources != undefined {
		var file_resource_names = variable_struct_get_names(file_resources);
		var j = 0; repeat array_length(file_resource_names) {
			var resource_name = file_resource_names[j++];
			resource_map[$resource_name] = file_resources[$resource_name];
		}
	}
	
	return resource_map;
}