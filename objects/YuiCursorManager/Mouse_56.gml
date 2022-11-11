/// @description find and run left_clicked handler

var click_time = current_time - click_start_time;

var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("released instance", i, "is", next.id, "type", object_get_name(next.object_index));
	
	if instance_exists(next)
		&& isCursorOnVisiblePart(next)
		&& yui_array_contains(mouse_down_array[mb_left], next) {
				
		// check double click
		if next.left_double_click {
				
			// do double click if this is the second click
			if click_count > 0 {
				yui_log("calling double click");
				click_count = 0;
				click_start_time = 0;
				clearQueuedEvent();
				next.left_double_click();
				break;
			}
				
			// otherwise queue the click to run when the double click interval expires
			var click_delay = double_click_interval_ms - click_time;
			if next.left_click && click_delay > 0 {
				yui_log("queued click in", click_delay, "ms");
				queueEvent("click", next, next.left_click, click_delay);
				break;
			}
			
			if click_count = 0 {
				click_count++;
			}
		}
		
		if next.left_click {
						
			yui_log("clicked instance", i, "is", next.id, "type", object_get_name(next.object_index));
			var handled = next.left_click();
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
	
	i--;
}
// forget the list
mouse_down_array[mb_left] = [];





