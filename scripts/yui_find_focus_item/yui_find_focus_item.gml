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
	
	switch direction {
		case YUI_FOCUS_DIRECTION.UP:
			var edge_x = current_item.x;
			var edge_y = 0;
			break;
		case YUI_FOCUS_DIRECTION.DOWN:
			var edge_x = current_item.x;
			var edge_y = window_get_height();
			break;
		case YUI_FOCUS_DIRECTION.LEFT:
			var edge_x = 0;
			var edge_y = current_item.y;
			break;
		case YUI_FOCUS_DIRECTION.RIGHT:
			var edge_x = window_get_width();
			var edge_y = current_item.y;
			break;
	}
	
	// do we need to convert to game coords??

	ds_list_clear(list);
	var count = collision_line_list(
		current_item.x,
		current_item.y,
		edge_x,
		edge_y,
		yui_cursor_item,
		precise,
		true, // notme
		list,
		true); // ordered
		
	var i = 0; repeat count {
		var target = list[| i++];
		
		if target.id != current_item.id && target.focusable {
			return target;
		}
	}
}