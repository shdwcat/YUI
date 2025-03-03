/// @description creates a top level YUI document
function YuiDocument(_yui_file, cabinet) constructor {
	yui_file = _yui_file;
	self.cabinet = cabinet;
	
	load_error = undefined;
	
	// for the loaded document
	static default_props = {
		id: undefined,
		data_type: undefined,
		import: [], // list of .yui filepaths relative to the yui_file
		resources: {},
		root: undefined,
		trace: false,
	}
	
	loadDocument();
	
	static loadDocument = function() {
		
		var yui_filepath = YUI_LIVE_RELOAD_ENABLED
			? YUI_LOCAL_PROJECT_DATA_FOLDER + yui_file
			: yui_file;
		
		if !file_exists(yui_filepath) {
			load_error = $"Could not find yui document file at {yui_filepath}";
			yui_error(load_error);
			return;
		}
		
		var cabinet_file = cabinet.file(yui_filepath);
		
		if cabinet_file == undefined {
			throw yui_error($"YuiDocument: Unable to find file at {yui_filepath}. Please turn on CABINET_VERBOSE_LOGGING to see verbose logs.");
		}
		
		// load the file data (possibly cached)
		var time = current_time;
		yui_log($"loading yui_file {yui_filepath}");
		var file_data = cabinet_file.tryRead();		
		
		if file_data[$ "trace"]
			DEBUG_BREAK_YUI
		
		// apply default props
		var document_data = yui_apply_props(file_data);
		
		if document_data.trace 
			DEBUG_BREAK_YUI
		
		// resolve imports
		var yui_folder = filename_dir(yui_filepath);
		resources = yui_resolve_resource_imports(
			document_data.resources,
			document_data.import,
			yui_folder,
			cabinet);
		
		// resolve root element
		root_element = yui_resolve_element(document_data.root, resources, undefined, document_data.id);
		var elapsed = current_time - time;
		yui_log($"Load completed in {elapsed/1000} seconds");
	}
}