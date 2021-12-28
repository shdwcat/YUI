/// @description check overlay GUI hotspots

// get mouse position once per frame
cursor_state_gui = {
	x: device_mouse_x_to_gui(device_index),
	y: device_mouse_y_to_gui(device_index),
};

// ===== run mouse hover logic =====

ds_list_clear(hover_list);

// first get yui_game_item from the room coordinates
// NOTE: we do this first because we'll interate this list in reverse for top-down behavior
hover_count = instance_position_list(
	mouse_x,
	mouse_y,
	yui_game_item,
	hover_list,
	false);
	
// then get the yui items from the UI layer
hover_count += instance_position_list(
	device_mouse_x_to_gui(0),
	device_mouse_y_to_gui(0),
	yui_base,
	hover_list,
	false);


var hover_consumed = false;

// check hover now so that it's available to item build/arrange
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("list instance", i, "is", next.id, "type", script_get_name(next.element_constructor));
	
	// should I rename this to hover to prevent confusion?
	next.highlight = true;
	
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
	// this runs the logic but how do we draw the things?
	var interaction_result = active_interaction.update(visual_item, cursor_state_gui);		
}