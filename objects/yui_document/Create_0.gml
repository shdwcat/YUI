/// @description init

persistent = persist;

// auto-init globals if it doesn't exist
if !instance_exists(YuiGlobals) {
	instance_create_depth(0, 0, depth, YuiGlobals);
}

// default to quick start screen if yui_file is not set
if yui_file == "" {
	yui_file = "YUI/quick_start_screen.yui";
	yui_warning("yui_document in", room_get_name(room), "does not have 'yui_file' value set, using 'YUI/quick_start_screen.yui' as a backup");
}

// the document describing what to render
document = undefined;

// error encountered when attempting to load the document
document_error = undefined;

// the actual render instance root
root = undefined;

// whether the document is being unloaded
is_unloading = false;

// simplifies logic in render items
enabled = true

// calculate the space we were given to draw in
calcSize = function() {
	if is_full_screen {
		x = 0;
		y = 0;
		draw_rect = {
			x: 0,
			y: 0,
			w: display_get_gui_width(),
			h: display_get_gui_height(),
		};
	}
	else {
		draw_rect = {
			x: x,
			y: y,
			w: bbox_right - bbox_left,
			h: bbox_bottom - bbox_top,
		};
	}
}

load = function() {
	is_unloading = false;
	document = new YuiDocument(yui_file, YuiGlobals.yui_cabinet);
	document_error = document.load_error
	if document_error != undefined {
		return;
	}	
	
	var element = document.root_element;

	root = yui_make_render_instance(element, data_context);
	root.parent = undefined;
	root.arrange(draw_rect);
}

reload = function(destroy_now = false) {
	if is_unloading return;
	
	var is_reload = instance_exists(root);
	
	if destroy_now {
		if instance_exists(root)
			root.destroy();
	}
	
	var unload_time = instance_exists(root)
		? root.unload()
		: 0;
	
	//yui_log($"document unload time is {unload_time} - {yui_file}");
	//yui_log($"is reload: {is_reload}");
	
	if unload_time > 0 {
		is_unloading = true;
		call_later(unload_time / 1000, time_source_units_seconds, load);
	}
	else {
		load();
	}
}

resize = function() {
	calcSize();
	if root != undefined {
		root.arrange(draw_rect);
	}
}	

calcSize();
load();