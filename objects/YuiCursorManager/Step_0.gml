/// @description check cursor hover and run interaction

var print_debug = keyboard_check_pressed(vk_shift)

// get gui mouse position once per frame
var mouse_gui_x = device_mouse_x_to_gui(device_index);
var mouse_gui_y = device_mouse_y_to_gui(device_index);

// reset click count if interval has expired
if click_count > 0 {
	var click_elapsed = current_time - double_click_start_time;
	if click_elapsed > double_click_interval_ms {
		click_count = 0;
		double_click_start_time = 0;
	}
}

// ===== run mouse hover logic =====

if !ds_list_empty(hover_list) {
	ds_list_clear(hover_list);
}

if cursor_offset_x != 0 || cursor_offset_y != 0 {
	image_xscale = -cursor_offset_x;
	image_yscale = -cursor_offset_y;

	// first get yui_game_items from the room coordinates
	// NOTE: we do this first because we'll interate this list in reverse for top-down behavior
	hover_count = instance_place_list(
		mouse_x + cursor_offset_x,
		mouse_y + cursor_offset_y,
		yui_game_item,
		hover_list,
		false);
	
	// then get the yui items from the UI layer
	hover_count += instance_place_list(
		mouse_gui_x + cursor_offset_x,
		mouse_gui_y + cursor_offset_y,
		yui_base,
		hover_list,
		false);
}
else {
	hover_count = instance_position_list(
		mouse_x,
		mouse_y,
		yui_game_item,
		hover_list,
		false);
	
	hover_count += instance_position_list(
		mouse_gui_x,
		mouse_gui_y,
		yui_base,
		hover_list,
		false);
}

// copy to array for easier manipulation
array_resize(hover_array, hover_count);
var i = 0; repeat hover_count {
	hover_array[i] = hover_list[| i];
	i++;
}

// sort by depth
array_sort(hover_array, function(a,b) {
	
	// sort yui_base (UI layer) items first
	var a_type = object_is_ancestor(a.object_index, yui_base) ? 1 : 2;
	var b_type = object_is_ancestor(b.object_index, yui_base) ? 1 : 2;
	if a_type != b_type {
		return a_type - b_type;
	}
	
	return a.depth - b.depth; 
});

var hover_consumed = false;

// set internal highlight flag to false
var keys = ds_map_keys_to_array(highlight_map);
var i = 0; repeat ds_map_size(highlight_map) {
	highlight_map[? keys[i++]] = false;
}

// check hover now so that it's available to item build/arrange
var i = 0; repeat hover_count {
	var next = hover_array[i];
	
	if print_debug {
		if object_is_ancestor(next.object_index, yui_base) {
			yui_log($"list instance {i} depth {next.depth} is {next.id} type {script_get_name(next.element_constructor)} and id {next._id}");
		}
		else {
			yui_log($"list instance {i} depth {next.depth} is {next.id} type {object_get_name(next.object_index)}");
		}
	}
	
	// skip if cursor is not on a visible part of the element
	if !isCursorOnVisiblePart(next) {
		i++;
		continue;
	}
	
	// TODO rename this to hover to prevent confusion

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
	
	i++;
}


if print_debug
	yui_break();

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