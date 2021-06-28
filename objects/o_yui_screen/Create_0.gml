/// @description init yui_component

// Inherit the parent event
event_inherited();

// hack for loading screens across rooms
if yui_file == "" {
	yui_file = global.__yui_pending_screen_file;
}

setFullScreen = function() {
	draw_region = {
		x: 0,
		y: 0,
		w: camera_get_view_width(view_camera[view_current]),
		h: camera_get_view_height(view_camera[view_current]),
	};
}


if draw_full_screen {
	setFullScreen();
}
else {
	draw_region = {
		x: x,
		y: y,
		w: bbox_right - bbox_left,
		h: bbox_bottom - bbox_top,
	};
}

lost_focus = false;
		
// TODO: check YuiGlobals exists and warn
yui_document = new YuiDocument(yui_file);

frame_count = 0;

if frame_cadence < 1 {
	yui_error("yui_screen frame_cadence cannot be less than 1");
	frame_cadence = 1;
}