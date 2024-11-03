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
	
	// the scope to check will be the scope of the current item, unless that
	// item is the root of its scope, in which case check the parent scope
	var scope = current_item.is_focus_root && current_item.focus_scope.parent
		? current_item.focus_scope.parent
		: current_item.focus_scope;
	
	var item_center_x = mean(current_item.bbox_left, current_item.bbox_right);
	var item_center_y = mean(current_item.bbox_top, current_item.bbox_bottom);
	
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
		false); // order only works for target X/Y but we need bbox center

	// find the closest focusable item in the list (by bbox center)
	var closest_item = undefined;
	var shortest_distance = infinity;
	var i = 0; repeat count {
		var target = list[| i++];
		
		// the target must be focusable or a focus scope root
		var is_valid = target.id != current_item.id && scope.matches(target)
			&& (target.focusable || target.is_focus_root);
		if !is_valid {
			continue;
		}
		
		var bbox_center_x = mean(target.bbox_left, target.bbox_right);
		var bbox_center_y = mean(target.bbox_top, target.bbox_bottom);
		var distance = point_distance(
			item_center_x, item_center_y,
			bbox_center_x, bbox_center_y);
		
		if current_item.trace
			yui_log($"distance is {distance} to {target._id} for scope {scope.id}");
			
		if distance < shortest_distance {
			shortest_distance = distance;
			
			// if the target isn't focusable then get the scope's focus
			closest_item = target.focusable
				? target
				: (target.focus_scope.focused_item ?? target.focus_scope.autofocus_target);
		}
	}
	
	// return the closest item if we found it
	if closest_item != undefined {
		return closest_item;
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
	closest_item = undefined;
	shortest_distance = infinity;
	var i = 0; repeat count {
		var target = list[| i++];
		
		if current_item.trace yui_log($"checking wide {target._id} for scope {scope.id}");
		
		// the target must be focusable or a focus scope root
		var is_valid = target.id != current_item.id && scope.matches(target)
			&& (target.focusable || target.is_focus_root);
		if !is_valid {
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
			mean(target.bbox_left, target.bbox_right),
			mean(target.bbox_top, target.bbox_bottom));
			
		if distance < shortest_distance {
			shortest_distance = distance;
			
			// if the target isn't focusable then get the scope's focus
			closest_item = target.focusable
				? target
				: (target.focus_scope.focused_item ?? target.focus_scope.autofocus_target);
		}
	}
	
	if closest_item == undefined {
		
		// try navigating from the scope root
		if current_item != scope.root_item {
			// if the scope's root is focusable then focus that
			// otherwise, try navigating from the root itself 
			if scope.root_item.focusable
				return scope.root_item;
			else {
				yui_log($"target not found, attempting to navigate from scope root: {scope.root_item._id}");
				return yui_find_focus_item(scope.root_item, list, direction, precise);
			}
		}
		// otherwise, try navigating from the parent scope
		else if scope.parent {
			if scope.parent.focused_item {
				yui_log($"target not found, returning focused item from parent scope {scope.parent.id}");
				return scope.parent.focused_item;
			}
		}
	}
	
	return closest_item;
}