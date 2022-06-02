/// @description init

runner_temp_folder = yui_get_runner_temp_folder();

selection_scopes = ds_map_create();

screens = {};
interactions = {};

yui_file_generator = function (text, cabinet_file) {
	var snap = snap_from_yui(text);
	var type = snap[$ "file_type"] ?? "unknown";
	switch type {
		case "screen":
			screens[$ snap.id] = cabinet_file;
			break;
		case "interaction":
			interactions[$ snap.id] = cabinet_file;
			cabinet_file.interaction_type = snap.type;
			break;
		case "resources":
			// nothing custom yet
			break;
	}
}

var options = {
	file_value_generator: yui_file_generator,
};

yui_cabinet = new Cabinet(YUI_DATA_SUBFOLDER, ".yui", options, function(cabinet_file) {
	cabinet_file.tryRead();
});

yui_log("loaded globals");



