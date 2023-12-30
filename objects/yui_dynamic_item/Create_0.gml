/// @description

// Inherit the parent event
event_inherited();

// the render instance for the resolved template element
content_item = undefined;

build = function() {
	
	opacity = parent.opacity
	
	// make/update the child item
	if content_item {
		content_item.unload();
		content_item = undefined;
	}
	if bound_values.content != undefined {
		var content_element = yui_element.getDynamicElement(bound_values.content);
		if content_element {
			content_item = yui_make_render_instance(content_element, data_context);
		}
		// else: log no matching data template?
	}
}

// forward the rest to the child item or vice versa

arrange = function(available_size, viewport_size) {
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if content_item {
		content_item.arrange(available_size, viewport_size);
		yui_resize_instance(content_item.draw_size.w, content_item.draw_size.h)
		
		// probably unnecessary but keeping for reference
		//if viewport_size {
		//	updateViewport();
		//}
		
		if content_item.is_size_changed {
			is_size_changed = true;
		}
	}
	return draw_size;
}

move = function(xoffset, yoffset) {
	if content_item {
		content_item.move(xoffset, yoffset);
	}
}

resize = function(width, height) {
	if content_item {
		yui_resize_instance(width, height);
		content_item.resize(width, height);
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
	
	if content_item {
		unload_time = max(unload_time, content_item.unload(unload_root_item));
	}

	return unload_time;
}