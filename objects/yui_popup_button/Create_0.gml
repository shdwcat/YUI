/// @description 

// Inherit the parent event
event_inherited();

is_popup_visible = false;
popup_item = undefined;

// do we need to override build?

button_arrange = arrange;
arrange = function(available_size) {
	var size = button_arrange(available_size);
	if popup_item {
		var popup_space = yui_calc_popup_space(popup_item);
		
		// we can't arrange here because final positions haven't been set
		// (e.g. the popup button is right aligned in a panel)
		// TODO: set the popup_space and cue it to re-arrange on its next pass		
		//popup_item.arrange(popup_space);
	}
	return size;
}

left_click = function() {
	// TODO do we need to call base?
	// only if we support on_click in addition to popup toggle
	
	is_popup_visible = !is_popup_visible;
	if is_popup_visible {
	
		// make sure we don't orphan an existing item
		if popup_item {
			instance_destroy(popup_item);
		}
	
		popup_item = yui_make_render_instance(bound_values.popup_element, bound_values.data_source, ,100);
	
		var popup_space = yui_calc_popup_space(popup_item);
		popup_item.arrange(popup_space);
	}
	else {
		instance_destroy(popup_item);
		popup_item = undefined;
	}
}