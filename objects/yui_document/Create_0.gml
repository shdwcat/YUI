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

// the actual render instance root
root = undefined;

// the space we were given to draw in
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

load = function() {
	document = new YuiDocument(yui_file, YuiGlobals.yui_cabinet);
	document_error = document.load_error
	if document_error != undefined {
		return;
	}	
	
	var element = document.root_element;

	root = yui_make_render_instance(element, data_context);
	root.parent = undefined;
	root.document = self;
	root.arrange(draw_rect);
}

reload = function(destroy_now = false) {
	if destroy_now {
		// TODO force destroy with no animations
		
		throw "not implemented";
	}
	
	var unload_time = instance_exists(root)
		? root.unload()
		: 0;
	
	yui_log("document unload time is", unload_time);
	
	if unload_time > 0 {
		call_later(unload_time / 1000, time_source_units_seconds, load);
	}
	else {
		load();
	}
}

load();