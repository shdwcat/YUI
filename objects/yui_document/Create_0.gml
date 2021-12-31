/// @description init

persistent = persist;

document = undefined;
root = undefined;

// defining this makes 'visual ancestor' search code simpler
parent = undefined;

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
	document = new YuiDocument(yui_file);
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