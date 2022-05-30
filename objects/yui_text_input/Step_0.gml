/// @description input_string tick

if focused {
	input_string_tick();
	
	if live_text == undefined {
		original_text = content_item.bound_values.text ?? "";
		input_string_set(original_text);
	}
	
	var current = input_string_get();
	
	if (update || current != live_text) {
		update = false;
		live_text = current;
		
		var old_font = draw_get_font();
		draw_set_font(content_item.font);
		
		caret_x = content_item.draw_size.x + string_width(live_text);
		
		draw_set_font(old_font);
	
		// override the bound text of the yui_text item
		content_item.override_text = live_text + after_caret;
	
		// rebuild and rearrange
		content_item.build();
		content_item.arrange(content_item.draw_rect);
		
		// only update our size if child size actually changed
		if content_item.is_size_changed {
			onChildLayoutComplete(content_item);
		}
	}
}



