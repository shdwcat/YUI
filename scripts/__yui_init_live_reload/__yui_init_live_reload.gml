// the path to the datafiles folder in the actual project
#macro YUI_LOCAL_PROJECT_DATA_FOLDER global.__yui_local_project_data_folder

// what state live reload is in, for error messaging
#macro YUI_LIVE_RELOAD_STATE global.__yui_live_reload_state

// whether live reload is enabled
#macro YUI_LIVE_RELOAD_ENABLED global.__yui_live_reload_enabled

#macro YUI_COMPILER_ENABLED YUI_ENABLE_COMPILER && YUI_LIVE_RELOAD_ENABLED

enum YUI_LIVE_RELOAD_STATES {
	NOT_CONFIGURED,
	SANDBOX_ENABLED,
	FOLDER_INCORRECT,
	ENABLED,
}	

function __yui_init_live_reload() {
	
	global.__yui_live_reload_configured = YUI_USER_PROJECT_DATA_FOLDER != undefined
		
	global.__yui_is_sandboxed = yui_is_fs_sandbox_enabled();
	
	YUI_LOCAL_PROJECT_DATA_FOLDER = YUI_USER_PROJECT_DATA_FOLDER ?? (__yui_get_backup_data_folder() ?? "");
	
	if !global.__yui_live_reload_configured {
		YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.NOT_CONFIGURED;
	}
	else if global.__yui_is_sandboxed {
		YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.SANDBOX_ENABLED;
	}
	else if !directory_exists(YUI_LOCAL_PROJECT_DATA_FOLDER) {
		YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.FOLDER_INCORRECT;
	}
	else {
		YUI_LIVE_RELOAD_STATE = YUI_LIVE_RELOAD_STATES.ENABLED;
	}

	// TODO: option to enable/disable in release mode (aka not debugger)?
	YUI_LIVE_RELOAD_ENABLED = YUI_LIVE_RELOAD_STATE == YUI_LIVE_RELOAD_STATES.ENABLED;
}





// fallback handling to run on @shdwcat's machine :D
function __yui_get_backup_data_folder() {
	
	var backup_folder = "D:/Projects/Game Design/YUI/datafiles/";
	
	if !global.__yui_is_sandboxed && directory_exists(backup_folder) {
		
		// pretend it was configured correctly
		global.__yui_live_reload_configured = true;
		
		return backup_folder;
	}
}

