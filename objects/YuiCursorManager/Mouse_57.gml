/// @description find and run right_clicked handler

var i = 0; repeat hover_count {
	var next = hover_array[i];
	
	if instance_exists(next) {
		if next.right_click
			&& isCursorOnVisiblePart(next)
			&& yui_array_contains(mouse_down_array[mb_right], next) {
				
			//yui_log("clicked instance", i, "is", next.id, "type", object_get_name(next.object_index));
			var handled = next.right_click();
			if handled != false {
				break;
			}
		}
	
		// a cursor layer blocks all events from propagating below it
		// e.g. popups and windows
		if instance_exists(next) && next.is_cursor_layer {
			break;
		}
	}
	
	i++;
}

// forget the list
mouse_down_array[mb_right] = [];


