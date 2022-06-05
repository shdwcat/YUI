/// @description here
function YuiExampleManager() constructor {

	yui_log("Welcome to the YUI Example Project!");
		
	app_name = "Example Project";
	
	static toggleTheme = function(theme_name) {
		// so hacky
		var first = YuiGlobals.themes[$"default"];
		var second = YuiGlobals.themes[$"pink!"];
		var first_path = first.fullpath;
		first.fullpath = second.fullpath;
		second.fullpath = first_path;
		
		YuiGlobals.yui_cabinet.clearCache();
		with yui_document {
			reload();
		}
	}
	
	var items_file = string_from_file("Example Data/inventory.yaml")
	var inventory = snap_from_yaml(items_file);
	
	slots = inventory.slots;
	items = inventory.items;
	
	foreach(slots, function(slot) {
			slot.equipped_item = { name: undefined, sprite: undefined }
		});
	
	widget_data = new WidgetGalleryData();
	
	// for viewport demo
	scroll_x = 0;
	scroll_y = 0;
	scroll_info = {
		x_max: 13,
		y_max: 13,
	};
	
	// set live reload status
	switch YUI_LIVE_RELOAD_STATE {
		case YUI_LIVE_RELOAD_STATES.NOT_CONFIGURED:
			live_reload_label = "Live Reload: NOT CONFIGURED";
			live_reload_message = "Live Reload is not configured. See instructions in Configure Me! (YUI) folder in the Asset Browser";
			break;
		case YUI_LIVE_RELOAD_STATES.SANDBOX_ENABLED:
			live_reload_label = "Live Reload: DISABLED";
			live_reload_message = "File System Sandbox must be disabled for Live Reload. Check Game Options > Windows.";
			break;
		case YUI_LIVE_RELOAD_STATES.FOLDER_INCORRECT:
			live_reload_label = "Live Reload: ERROR";
			live_reload_message = "Project datafiles folder does not exist: " + YUI_LOCAL_PROJECT_DATA_FOLDER;
			break;
		case YUI_LIVE_RELOAD_STATES.ENABLED:
			live_reload_label = "Live Reload: ENABLED";
			live_reload_message = "Press F5 to reload .yui files from disk";
			break;
	}
	
	yui_log("Example project loaded");
}