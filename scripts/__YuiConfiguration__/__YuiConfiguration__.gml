// ==============================
// |     YUI Configuration      |
// |                            |
// |   Please edit this file!   |
// ==============================

// For Live Reload to work, YUI needs to know the FULL path to the 'datafiles' folder for your project.
// e.g. "D:/Projects/Game Design/YUI/datafiles/"
#macro YUI_LOCAL_PROJECT_DATA_FOLDER undefined

// YUI also needs to know which folder in /datafiles/ contains the .yui files for the UI.
// In the Example Project, they're located in /datafiles//YUI/ but you can change that here.
#macro YUI_DATA_SUBFOLDER "YUI/"







// ========= Validation Section - DO NOT EDIT =========

if YUI_LOCAL_PROJECT_DATA_FOLDER == undefined {
	yui_warning("YUI Live Reload is not configured! Please edit __YuiConfiguration__ to enable.")
}



// ========= Live Reload Set-Up Section - DO NOT EDIT =========

global.__yui_local_project_data_folder = YUI_LOCAL_PROJECT_DATA_FOLDER;

if YUI_LOCAL_PROJECT_DATA_FOLDER == undefined {
	
	// fallback handling to run on @shdwcat's machine :P
	global.__yui_local_project_data_folder = "D:/Projects/Game Design/YUI/datafiles/";
}

global.__yui_live_reload_enabled = directory_exists(global.__yui_local_project_data_folder);

