/// @description 

wheel_up_consumed = false;
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
	
	if instance_exists(next) {
		if next.on_mouse_wheel_up {
			//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
			wheel_up_consumed = next.on_mouse_wheel_up() != false;
			if wheel_up_consumed {
				break;
			}
		}
	
		// a cursor layer blocks all events from propagating below it
		// e.g. popups and windows
		if next.is_cursor_layer {
			break;
		}
	}
	
	i--;
}

if i < 0 && global_wheel_up {
	global_wheel_up();
}

