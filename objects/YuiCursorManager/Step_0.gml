/// @description check cursor hover and run interaction

// get mouse position once per frame
var mouse_gui_x = device_mouse_x_to_gui(device_index);
var mouse_gui_y = device_mouse_y_to_gui(device_index);

// get mouse position once per frame


// ===== run mouse hover logic =====

if !ds_list_empty(hover_list) {
	ds_list_clear(hover_list);
}

// first get yui_game_items from the room coordinates
// NOTE: we do this first because we'll interate this list in reverse for top-down behavior
hover_count = instance_position_list(
	mouse_x,
	mouse_y,
	yui_game_item,
	hover_list,
	false);
	
// then get the yui items from the UI layer
hover_count += instance_position_list(
	mouse_gui_x,
	mouse_gui_y,
	yui_base,
	hover_list,
	false);

// copy to array for easier debugging
array_resize(hover_array, hover_count);
var i = hover_count - 1; repeat hover_count {
	hover_array[i] = hover_list[| i];
	i--;
}

var hover_consumed = false;

// check hover now so that it's available to item build/arrange
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("list instance", i, "is", next.id, "type", script_get_name(next.element_constructor));
	
	// should I rename this to hover to prevent confusion?
	next.setHighlight(true);
	
	if !hover_consumed && next.cursor_hover {
		//yui_log("hover instance", i, "is", next.id, "type", object_get_name(next.object_index));
		var handled = next.cursor_hover();
		hover_consumed = handled != false;
		break;
	}
	
	// a cursor layer blocks all events from propagating below it
	// e.g. popups and windows
	if next.is_cursor_layer {
		break;
	}
	
	i--;
}

// ===== run interaction =====

if active_interaction {
	var cursor_state_gui = {
		x: mouse_gui_x,
		y: mouse_gui_y,
	};
	var interaction_result = active_interaction.update(visual_item, cursor_state_gui);		
}