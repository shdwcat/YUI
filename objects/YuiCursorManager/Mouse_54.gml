/// @description find and run right_pressed handler

click_start_time = current_time;

right_pressed_consumed = false;
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("list instance", i, "is", next.id, "type", script_get_name(next.element_constructor));
	
	if instance_exists(next) {
		if next.right_pressed && isCursorOnVisiblePart(next) {
			yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
			right_pressed_consumed = next.right_pressed() != false;
			if right_pressed_consumed {
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
trackMouseDownItems(mb_right);

