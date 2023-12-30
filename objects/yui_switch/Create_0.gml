/// @description init

// Inherit the parent event
event_inherited();

case_item = undefined;

build = function() {
	// clear out the old item;
	if case_item {
		case_item.unload();
		case_item = undefined;
	}
	
	opacity = parent.opacity
	
	// make/update the child item
	if bound_values.switch_value != undefined {
		if typeof(bound_values.switch_value) == "bool" {
			var key = bound_values.switch_value == 1
				? "true"
				: "false";
		}
		else {
			var key = string(bound_values.switch_value);
		}
		
		var case_element = yui_element.getCaseElement(key);
		if case_element {
			case_item = yui_make_render_instance(case_element, data_context);
		}
	}
}

// forward the rest to the child item or vice versa

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !case_item 
		return sizeToDefault();
	
	case_item.arrange(available_size, viewport_size);
	x = case_item.x;
	y = case_item.y;
		
	yui_resize_instance(case_item.draw_size.w, case_item.draw_size.h)
	
	// probably unnecessary but keeping for reference
	//if viewport_size {
	//	updateViewport();
	//}
		
	if case_item.is_size_changed {
		is_size_changed = true;
	}
	
	return draw_size;
}

base_move = move;
move = function(xoffset, yoffset) {
	if case_item {
		case_item.move(xoffset, yoffset);
	}
}

resize = function(width, height) {
	if case_item {
		yui_resize_instance(width, height);
		case_item.resize(width, height);
	}
}

onChildLayoutComplete = function(child) {
	if parent {
		parent.onChildLayoutComplete(self);
	}
}

base_unload = unload;
unload = function(unload_root = undefined) {
	var unload_time = base_unload(unload_root);
	
	if case_item {
		unload_time = max(unload_time, case_item.unload(unload_root_item));
	}

	return unload_time;
}