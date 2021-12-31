// gets the full path to the local temp folder for the runner (where data files are copied at launch)
function yui_get_runner_temp_folder() {
	
	// check if we're in beta via the GM runtime version
	// Beta is ##.blah
	// Release is #.#.blah
	// TODO: move this into yui_get_runner_temp_folder
	var dot_pos = string_pos(".", GM_runtime_version)
	var is_beta = dot_pos != 2;

	if parameter_count() > 2 && parameter_string(1) == "-game" {
		var temp_bundle = parameter_string(2);
		
		var tokens = yui_string_split(temp_bundle, "\\");
		
		var temp_folder_name = yui_string_after(tokens[0], "Y:/");
		var temp_root = yui_string_before(game_save_id, game_project_name + "\\");
		
		var gms_path = is_beta
			? "GameMakerStudio2-Beta\\GMS2TEMP\\"
			: "GameMakerStudio2\\GMS2TEMP\\";
		var path = temp_root + gms_path + temp_folder_name + "\\";
		return path;
	}
	else {
		return undefined;
	}
}