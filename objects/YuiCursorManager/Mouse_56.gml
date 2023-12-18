/// @description find and run left_clicked handler

var click_elapsed = current_time - double_click_start_time;

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
				yui_log($"calling double click - elapsed was {click_elapsed}");
				var handled = next.left_double_click();
				if handled != false {
					click_count = 0;
					clearQueuedEvent();
					break;
				}
				
				// if this element isn't a cursor layer, allow the remaining elements to handle the double click
				if !next.is_cursor_layer {
					continue;
				}
			}

			// otherwise queue the click to run when the double click interval expires
			// note: not currently able to bubble this event if the handler returns false
			var click_delay = double_click_interval_ms - click_elapsed;
			if next.left_click && click_delay > 0 {
				yui_log($"queued click in {click_delay} ms");
				queueEvent("click", next, next.left_click, click_delay);
				break;
			}
			
			// track that one click has already happened
			click_count++;
		}
		
		if next.left_click {
			
			// if we started a double click above, queue this click to happen later
			if queued_event == undefined && click_count > 0 {
				var click_delay = double_click_interval_ms - click_elapsed;
				queueEvent("click", next, next.left_click, click_delay);
				break;
			}
			
			//yui_log("clicked instance", i, "is", next.id, "type", object_get_name(next.object_index));
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





