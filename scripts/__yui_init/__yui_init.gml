#macro YUI_VERSION "0.6.3"

yui_log("Welcome to YUI by @shdwcat - version " + YUI_VERSION);

#macro YUI_ASSET_USE_CSV "yui_asset_use_log.csv"

__yui_init_live_reload();

// reset log files
file_delete(YUI_LOCAL_PROJECT_DATA_FOLDER + YUI_ASSET_USE_CSV);

__yui_init_globals();