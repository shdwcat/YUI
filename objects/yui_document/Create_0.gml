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

// defining these makes 'visual ancestor' search code simpler
parent = undefined;
opacity = 1;

// the space we were given to draw in
if is_full_screen {
	draw_rect = {
		x: 0,
		y: 0,
		w: camera_get_view_width(view_camera[view_current]),
		h: camera_get_view_height(view_camera[view_current]),
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
	root.arrange(draw_rect);
}

reload = function() {
	instance_destroy(root);
	load();
}

load();

onChildLayoutComplete = function(child) {
	// this is just here to make the recursive call simpler in actual elements
}