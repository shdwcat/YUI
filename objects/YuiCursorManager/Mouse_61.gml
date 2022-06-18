/// @description 

wheel_down_consumed = false;
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
	
	if instance_exists(next) {
		if next.on_mouse_wheel_down {
			//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
			wheel_down_consumed = next.on_mouse_wheel_down() != false;
			if wheel_down_consumed {
				break;
			}
		}
	
		// a cursor layer blocks all events from propagating below it
		// e.g. popdowns and windows
		if next.is_cursor_layer {
			break;
		}
	}
	
	i--;
}
