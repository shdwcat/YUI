enum YUI_FOCUS_DIRECTION {
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8,
	
	// TODO:
	// flags
	//CYCLE = 16, // whether to cycle up from the bottom if nothing is found
}

/// @description
function yui_find_focus_item(current_item, list, direction, precise = false) {
	
	if !instance_exists(current_item) return undefined;
	var item_center_x = current_item.x + (current_item.bbox_right - current_item.bbox_left)/2;
	var item_center_y = current_item.y + (current_item.bbox_bottom - current_item.bbox_top)/2;
	
	switch direction {
		case YUI_FOCUS_DIRECTION.UP:
			var edge_x = item_center_x;
			var edge_y = 0;
			item_center_y = current_item.bbox_top;
			break;
		case YUI_FOCUS_DIRECTION.DOWN:
			var edge_x = item_center_x;
			var edge_y = window_get_height();
			item_center_y = current_item.bbox_bottom;
			break;
		case YUI_FOCUS_DIRECTION.LEFT:
			var edge_x = 0;
			var edge_y = item_center_y;
			item_center_x = current_item.bbox_left;
			break;
		case YUI_FOCUS_DIRECTION.RIGHT:
			var edge_x = window_get_width();
			var edge_y = item_center_y;
			item_center_x = current_item.bbox_right;
			break;
	}
	
	// do we need to convert to game coords??

	ds_list_clear(list);
	var count = collision_line_list(
		item_center_x,
		item_center_y,
		edge_x,
		edge_y,
		yui_cursor_item,
		precise,
		true, // notme (this is vaguely irrelevent, 'me' is YuiCursorManager)
		list,
		true); // ordered
	
	// find the first focusable item in the list (and return it if found)
	var i = 0; repeat count {
		var target = list[| i++];
		
		if target.id != current_item.id && target.focusable {
			return target;
		}
	}
	
	// fallback when nothing is directly in that direction: check the entire portion of the screen
	switch direction {
		case YUI_FOCUS_DIRECTION.UP:
			var rect_x1 = 0;
			var rect_y1 = 0;
			var rect_x2 = window_get_width();
			var rect_y2 = current_item.bbox_top;
			break;
		case YUI_FOCUS_DIRECTION.DOWN:
			var rect_x1 = 0;
			var rect_y1 = current_item.bbox_bottom;
			var rect_x2 = window_get_width();
			var rect_y2 = window_get_height();
			break;
		case YUI_FOCUS_DIRECTION.LEFT:
			var rect_x1 = 0;
			var rect_y1 = 0;
			var rect_x2 = current_item.bbox_left;
			var rect_y2 = window_get_height();
			break;
		case YUI_FOCUS_DIRECTION.RIGHT:
			var rect_x1 = current_item.bbox_right;
			var rect_y1 = 0;
			var rect_x2 = window_get_width();
			var rect_y2 = window_get_height();
			break;
	}
	
	ds_list_clear(list);
	count = collision_rectangle_list(
		rect_x1,
		rect_y1,
		rect_x2,
		rect_y2,
		yui_cursor_item,
		precise,
		true, // notme (this is vaguely irrelevent, 'me' is YuiCursorManager)
		list,
		false); // ordered
	
	// find the closest item from those in the rectangle	
	var closest_item = undefined;
	var shortest_distance = infinity;
	var i = 0; repeat count {
		var target = list[| i++];
		
		
		if target.id == current_item.id 
		|| target.focusable == false {
			continue;
		}
		
		// NOTE: collision_rectangle_list will snag items that overlap the rectangle
		// but we only want objects fully in the rectangle
		var is_in_rectangle = rectangle_in_rectangle(
			target.bbox_left,
			target.bbox_top,
			target.bbox_right,
			target.bbox_bottom,
			rect_x1,
			rect_y1,
			rect_x2,
			rect_y2);
		
		// 1 means fully encompassed, see manual for rectangle_in_rectangle()
		if is_in_rectangle != 1 {
			continue;
		}
		
		var distance = point_distance(
			item_center_x, item_center_y,
			target.x, target.y) // NOTE: not using target center, may cause problems!
			
		if distance < shortest_distance {
			shortest_distance = distance;
			closest_item = target;
		}
	}
	
	return closest_item;
}