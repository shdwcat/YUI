/// @description find and run right_pressed handler

right_pressed_consumed = false;
var i = 0; repeat hover_count {
	var next = hover_array[i];
	
	if instance_exists(next) {
		if next.right_pressed && isCursorOnVisiblePart(next) {
			//yui_log("pressed instance", i, "is", next.id, "type", object_get_name(next.object_index));
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
	
	i++;
}

trackMouseDownItems(mb_right);

