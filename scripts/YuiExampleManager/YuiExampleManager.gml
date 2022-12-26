/// @description here
function YuiExampleManager() constructor {

	yui_log("Welcome to the YUI Example Project!");
	
	checkLiveReload();
		
	app_name = "Example Project";
	
	layouts = {
		active_tab_index: 0
	};
	
	var items_file = yui_string_from_file("ExampleProject/Data/inventory.yaml")
	var inventory = snap_from_yui(items_file);
	
	slots = inventory.slots;
	items = inventory.items;
	
	array_foreach(slots, function(slot) {
		slot.equipped_item = { name: undefined, sprite: undefined }
	});
	
	widget_data = new WidgetGalleryData();
	
	// windows demo
	windows = {
		"default": new YuiWindowItem("buttons"),
		"pink": new YuiWindowItem("more buttons", , 300),
		"more": new YuiWindowItem("even more buttons", , 600),
	}
	
	window_list = [windows[$ "default"], windows.pink, windows.more];
	
	// for viewport demo
	scroll_x = 0;
	scroll_y = 0;
	scroll_info = {
		x_max: 13,
		y_max: 13,
	};
	
	test_opacity = 1;
			
	yui_log("Example project loaded");
	
	static checkLiveReload = function() {
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
	}
	
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
	
	toggleOpacity = function() {
		test_opacity = test_opacity == 1 ? .5 : 1;
	}
}