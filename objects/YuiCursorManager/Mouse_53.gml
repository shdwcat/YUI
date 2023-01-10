/// @description find and run left_pressed handler

// debug code
//var i = hover_count - 1; repeat hover_count {
//	var next = hover_list[| i];
//	yui_log("hover item at index", i, "is", next.id, "type", object_get_name(next.object_index), "depth", next.depth);
//	i--;
//}

left_pressed_consumed = false;
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
	
	if instance_exists(next) {
		
		// track the start of a double click
		if next.left_double_click && click_count == 0 {
			yui_log("tracking double click");
			double_click_start_time = current_time;
		}
		
		if next.left_pressed && isCursorOnVisiblePart(next) {
			//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
			left_pressed_consumed = next.left_pressed() != false;
			if left_pressed_consumed {
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

if i < 0 && global_left_pressed {
	global_left_pressed();
}
trackMouseDownItems(mb_left);
