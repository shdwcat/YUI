/// @description

// Inherit the parent event
event_inherited();

// the render instance for the resolved template element
template_item = undefined;

base_destroy = destroy;
destroy = function() {
	if template_item && instance_exists(template_item)
		template_item.destroy();
	base_destroy();
}

build = function() {
	
	opacity = parent.opacity
	
	// make/update the child item
	if template_item {
		template_item.unload();
		template_item = undefined;
	}
	if bound_values.resource_key != undefined {
		var template_element = yui_element.getTemplateElement(bound_values.resource_key);
		if template_element {
			template_item = yui_make_render_instance(template_element, data_context);
		}
		// else: log no matching data template?
	}
}

// forward the rest to the child item or vice versa

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if template_item {
		
		template_item.arrange(available_size, viewport_size);
		
		yui_resize_instance(template_item.draw_size.w, template_item.draw_size.h)
		
		// probably unnecessary but keeping for reference
		//if viewport_size {
		//	updateViewport();
		//}
		
		if template_item.is_size_changed {
			is_size_changed = true;
		}
	}
	return draw_size;
}

traverse = function(func, acc = undefined) {
	
	with self {
		// allow the traverse function to change the acc itself
		acc = func(acc) ?? acc;
	}
	
	if template_item {
		template_item.traverse(func, acc);
	}
}

move = function(xoffset, yoffset) {
	if template_item {
		template_item.move(xoffset, yoffset);
	}
}

resize = function(width, height) {
	if template_item {
		yui_resize_instance(width, height);
		template_item.resize(width, height);
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
	
	if template_item {
		unload_time = max(unload_time, template_item.unload(unload_root_item));
	}

	return unload_time;
}