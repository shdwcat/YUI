/// @description init

// Inherit the parent event
event_inherited();

case_item = undefined;

base_destroy = destroy;
destroy = function() {
	if case_item && instance_exists(case_item)
		case_item.destroy();
	base_destroy();
}

build = function() {
	// clear out the old item;
	if case_item {
		case_item.unload();
		case_item = undefined;
	}
	
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
			case_item = yui_make_render_instance(case_element, data_source);
		}
	}
	
	if case_item {
		// check if we need to rebuild
		case_item.rebuild = case_item.data_context != data_source;
		if case_item.rebuild {
			// update child data context
			case_item.data_context = data_source;
			// will trigger build() as child runs after this
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
	
	// we need to constrain the draw size by our element size
	// (border etc get this from padding logic)
	var available_rect = element_size.constrainDrawSize(available_size, available_size);
		
	var desired_size = {
		w: 0,
		h: 0,
	}
	
	if case_item {
		is_arranging = true;
		var content_size = case_item.arrange(available_rect, viewport_size);
		is_arranging = false;
		
		desired_size.w += content_size.w;
		desired_size.h += content_size.h;
	}
	
	x = case_item.x;
	y = case_item.y;
	
	var drawn_size = element_size.constrainDrawSize(available_size, desired_size);
		
	yui_resize_instance(drawn_size.w, drawn_size.h)
	
	// probably unnecessary but keeping for reference
	//if viewport_size {
	//	updateViewport();
	//}
		
	if case_item.is_size_changed {
		is_size_changed = true;
	}
	
	return draw_size;
}

traverse = function(func, acc = undefined) {
	
	with self {
		// allow the traverse function to change the acc itself
		acc = func(acc) ?? acc;
	}
	
	if case_item {
		case_item.traverse(func, acc);
	}
}

base_move = move;
move = function(xoffset, yoffset) {
	base_move(xoffset, yoffset);
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