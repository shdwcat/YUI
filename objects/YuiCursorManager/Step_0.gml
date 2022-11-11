/// @description check cursor hover and run interaction

// get mouse position once per frame
var mouse_gui_x = device_mouse_x_to_gui(device_index);
var mouse_gui_y = device_mouse_y_to_gui(device_index);

// reset click count if interval has expired
if click_count > 0 {
	var click_elapsed = current_time - click_start_time;
	if click_elapsed > double_click_interval_ms {
		click_count = 0;
	}
}

// ===== run mouse hover logic =====

if !ds_list_empty(hover_list) {
	ds_list_clear(hover_list);
}

// first get yui_game_items from the room coordinates
// NOTE: we do this first because we'll interate this list in reverse for top-down behavior
hover_count = instance_position_list(
	mouse_x + cursor_offset_x,
	mouse_y + cursor_offset_y,
	yui_game_item,
	hover_list,
	false);
	
// then get the yui items from the UI layer
hover_count += instance_position_list(
	mouse_gui_x + cursor_offset_x,
	mouse_gui_y + cursor_offset_y,
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

// set internal highlight flag to false
var keys = ds_map_keys_to_array(highlight_map);
var i = 0; repeat ds_map_size(highlight_map) {
	highlight_map[? keys[i++]] = false;
}

// check hover now so that it's available to item build/arrange
var i = hover_count - 1; repeat hover_count {
	var next = hover_list[| i];
	//yui_log("list instance", i, "is", next.id, "type", script_get_name(next.element_constructor));
	
	// skip if cursor is not on a visible part of the element
	if !isCursorOnVisiblePart(next) {
		i--;
		continue;
	}
	
	// should I rename this to hover to prevent confusion?

	// only set highlight if not already highlighted
	if !next.highlight {
		next.setHighlight(true);
	}

	// flag item as highlighted this frame
	highlight_map[? next] = true;
	
	//if !hover_consumed && next.cursor_hover {
	//	//yui_log("hover instance", i, "is", next.id, "type", object_get_name(next.object_index));
	//	var handled = next.cursor_hover();
	//	hover_consumed = handled != false;
	//	break;
	//}
	
	// a cursor layer blocks all events from propagating below it
	// e.g. popups and windows
	if next.is_cursor_layer {
		break;
	}
	
	i--;
}

// clear highlight from old items
var keys = ds_map_keys_to_array(highlight_map);
var i = 0; repeat ds_map_size(highlight_map) {
	var item = keys[i++];
	var highlighted = highlight_map[? item];

	if !highlighted {
		// clear highlight and remove from map

		if instance_exists(item) {
			item.setHighlight(false);
		}

		ds_map_delete(highlight_map, item);
	}
}

// ===== run interaction =====

if active_interaction {
	var cursor_state_gui = {
		x: mouse_gui_x,
		y: mouse_gui_y,
	};
	var interaction_result = active_interaction.update(visual_item, cursor_state_gui);		
}