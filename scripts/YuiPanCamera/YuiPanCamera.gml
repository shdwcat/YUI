/// @description here
function YuiPanCamera(_props, _resources) constructor {
	
	static default_props = {
		id: undefined,
		type: "pan_camera",
		
		camera_index: 0,
		pan_scale: 1,
		inertia_decay: .1,
		
		clamp_to_room: true,
		
		cursor_visual: undefined,
				
		trace: false,
	};
	
	props = yui_init_props(_props);
	resources = _resources;
	
	cursor_element = yui_resolve_element(props.cursor_visual, resources, undefined);
	
	static canStart = function(source_data) {
		return true;
	}
	
	static start = function(source_data, event, source_item) {
		
		// NOTE: assumes initiating event is a mouse button event
		button = event[$ "button"] ?? mb_left;
		
		cursor = {
			original_camera_x: camera_get_view_x(view_camera[props.camera_index]),
			original_camera_y: camera_get_view_y(view_camera[props.camera_index]),
			original_mouse_x: device_mouse_x_to_gui(0),
			original_mouse_y: device_mouse_y_to_gui(0),
			last_mouse_x: device_mouse_x_to_gui(0),
			last_mouse_y: device_mouse_y_to_gui(0),
		}
		
		is_inertia_scrolling = false;
		
		return cursor_element;
	}
	
	static update = function(visual_item, cursor_pos) {
				
		if mouse_check_button_released(button) {
			
			cursor.motion_dir = point_direction(cursor.last_mouse_x, cursor.last_mouse_y, cursor_pos.x, cursor_pos.y);
			cursor.motion_speed = point_distance(cursor.last_mouse_x, cursor.last_mouse_y, cursor_pos.x, cursor_pos.y);
			
			// on release, keep scrolling with inertia			
			if cursor.motion_speed > 0 {
				cursor.up_x = cursor_pos.x;
				cursor.up_y = cursor_pos.y;
				is_inertia_scrolling = true;
			}
			else {
				finish();
				return;
			}
		}
		
		if is_inertia_scrolling {
						
			cursor.up_x += lengthdir_x(cursor.motion_speed, cursor.motion_dir);
			cursor.up_y += lengthdir_y(cursor.motion_speed, cursor.motion_dir);
			
			var x_offset = cursor.up_x - cursor.original_mouse_x;
			var y_offset = cursor.up_y - cursor.original_mouse_y;
			
			// decay inertial speed
			cursor.motion_speed = cursor.motion_speed * (1 - props.inertia_decay);
		}
		else {						
			var x_offset = cursor_pos.x - cursor.original_mouse_x;
			var y_offset = cursor_pos.y - cursor.original_mouse_y;
		}		
		
		var camera_x_offset = x_offset * props.pan_scale;
		var camera_y_offset = y_offset * props.pan_scale;
		
		var camera_x = cursor.original_camera_x - camera_x_offset;
		var camera_y = cursor.original_camera_y - camera_y_offset;
		
		if props.clamp_to_room {
			camera_x = clamp(camera_x, 0, room_width);
			camera_y = clamp(camera_y, 0, room_height);
		}
		
		// position the visual at the mouse cursor
		if visual_item {
			var xdiff = cursor_pos.x - visual_item.x;
			var ydiff = cursor_pos.y - visual_item.y;
			visual_item.move(xdiff, ydiff);
		}
		
		//yui_log("setting camera to:", camera_x, camera_y);
		camera_set_view_pos(view_camera[props.camera_index], camera_x, camera_y);
		
		if is_inertia_scrolling && cursor.motion_speed <= 1 {
			finish();
			return;
		}
				
		cursor.last_mouse_x = cursor_pos.x;
		cursor.last_mouse_y = cursor_pos.y;
	}
	
	static resetFrame = function() {
		// nothing to reset here
	}
	
	static finish = function() {
		YuiCursorManager.finishInteraction();
		cursor = undefined;
		button = undefined;
	}
}