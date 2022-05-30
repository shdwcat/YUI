/// @description input_string tick

if focused {
	input_string_tick();
	
	if live_text == undefined {
		live_text = content_item.bound_values.text;
		
		original_text = live_text; // for undo
		
		input_string_set(live_text);
	}
	
	var current = input_string_get();
	
	if (current != live_text) {
		live_text = current;
		yui_log("live_text: " + live_text);
	
		// override the bound text of the yui_text item
		content_item.override_text = live_text;
	
		// rebuild and rearrange
		content_item.build();
		content_item.arrange(content_item.draw_rect);
		
		// only update our size if child size actually changed
		if content_item.is_size_changed {
			onChildLayoutComplete(content_item);
		}
	}
}


