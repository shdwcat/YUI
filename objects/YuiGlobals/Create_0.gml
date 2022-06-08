/// @description init

selection_scopes = ds_map_create();

screens = {};
interactions = {};
themes = {};

var yui_file_customizer = function(cabinet_file) {
	
	// scan the file type
	var file_type = cabinet_file.tryScanLines(function (line) {
		if string_pos("file_type: ", line) == 1 {
			return string_copy(line, 12, string_length(line) - 13);
		}
	});
	
	// store the file type and track special files
	cabinet_file.file_type = file_type;
	switch file_type {
		case "screen":
			screens[$ cabinet_file.file_id] = cabinet_file;
			break;
			
		case "interaction":
			interactions[$ cabinet_file.file_id] = cabinet_file;
			break;
			
		case "theme":
			themes[$ cabinet_file.file_id] = cabinet_file;
			break;
			
		case "resources":
			break;
	}
}

var yui_file_generator = function (text, cabinet_file) {
	var snap = snap_from_yui(text);
	
	switch cabinet_file.file_type {
		case "interaction":
			var interaction = yui_resolve_interaction(snap);
			return interaction;
			
		case "theme":
			var theme = yui_init_theme(snap, cabinet_file.directory);
			return theme;
			
		default:
			return snap;
	}
}

var options = {
	cabinet_file_customizer: yui_file_customizer,
	file_value_generator: yui_file_generator,
};

var yui_data_folder = YUI_LOCAL_PROJECT_DATA_FOLDER + YUI_DATA_SUBFOLDER;
yui_cabinet = new Cabinet(yui_data_folder, ".yui", options);

yui_log("YuiGlobals: loaded");
