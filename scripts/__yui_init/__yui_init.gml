#macro YUI_VERSION "0.6.6"

yui_log("Welcome to YUI by @shdwcat - version " + YUI_VERSION);

#macro YUI_ASSET_USE_CSV "logs/yui_asset_use_log.csv"

__yui_init_live_reload();

// reset log files
if GM_build_type == "run"
	yui_try_delete_file(YUI_LOCAL_PROJECT_DATA_FOLDER + YUI_ASSET_USE_CSV)
	
yui_log_to_datafile(YUI_ASSET_USE_CSV, "NAME, TYPE, SOURCE_EXPRESSION");

__yui_init_globals();