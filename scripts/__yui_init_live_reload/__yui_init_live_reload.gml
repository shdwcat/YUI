// the path to the datafiles folder in the actual project
#macro YUI_LOCAL_PROJECT_DATA_FOLDER global.__yui_local_project_data_folder

// what state live reload is in, for error messaging
#macro YUI_LIVE_RELOAD_STATE global.__yui_live_reload_state

// whether live reload is enabled
#macro YUI_LIVE_RELOAD_ENABLED global.__yui_live_reload_enabled


// move this to configure-me folder if/when compiler is actually useful
// whether to enable compiling bindings to GML (requires Live Reload to be configured)
#macro YUI_ENABLE_COMPILER false

#macro YUI_COMPILER_ENABLED YUI_ENABLE_COMPILER && YUI_LIVE_RELOAD_ENABLED

enum YUI_LIVE_RELOAD_STATES {
	RELEASE_MODE,
	SANDBOX_ENABLED,
	FOLDER_INCORRECT,
	ENABLED,
}

__yui_init_live_reload();

function __yui_init_live_reload() {
	
	if (GM_project_filename == undefined || GM_project_filename == "") {
		YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.RELEASE_MODE;
	}
	else {
		// get the datafiles folder path from the project file path
		var project_folder = string_trim_end(GM_project_filename, [game_project_name + ".yyp"]);
		var data_folder = string_replace_all(project_folder, "\\", "/") + "/datafiles/";	
		YUI_LOCAL_PROJECT_DATA_FOLDER = data_folder;
		
		global.__yui_is_sandboxed = yui_is_fs_sandbox_enabled();
		if global.__yui_is_sandboxed {
			YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.SANDBOX_ENABLED;
		}
		else if !directory_exists(YUI_LOCAL_PROJECT_DATA_FOLDER) {
			YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.FOLDER_INCORRECT;
		}
		else {
			YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.ENABLED;
		}
	}

	// TODO: option to enable/disable in release mode (aka not debugger)?
	YUI_LIVE_RELOAD_ENABLED = YUI_LIVE_RELOAD_STATE == YUI_LIVE_RELOAD_STATES.ENABLED;
}