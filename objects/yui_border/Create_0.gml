/// @description init

// Inherit the parent event
event_inherited();

default_props = {
	type: "border",
	//trace: true,
	content: "This is a test! Big Test! This is a test! Big Test!This is a test! Big Test!This is a test! Big Test!",
}

is_arranging = false;
has_content_item = true; // yui_panel sets this to false
content_item = undefined;

bg_alpha = undefined;

has_border_color = false;
has_focus_color = false;
draw_border = false;

base_destroy = destroy;
destroy = function() {
	if content_item && instance_exists(content_item)
		content_item.destroy();
	base_destroy();
}

onLayoutInit = function() {	
		
	if layout_props.border_color != undefined {
		has_border_color = true;
		border_color = layout_props.border_color;
		border_alpha = ((border_color & 0xFF000000) >> 24) / 255;
	}
	
	if layout_props.border_thickness != undefined {
		border_thickness = layout_props.border_thickness;
	}
	
	background_value = new YuiBindableValue(yui_element.background, yui_element.getDefaultAnim("background"));
	animatable.background = background_value
	
	if layout_props.border_focus_color != undefined {
		has_focus_color = true;
		border_focus_color = layout_props.border_focus_color;
	}
	else {
		border_focus_color = border_color;
	}
	
	draw_border =
		border_thickness > 0 
		&& (has_border_color || has_focus_color);
}

build = function() {
	
	// create the content item instance if there should be one
	var make_content_item = 
		has_content_item
		&& content_item == undefined
		&& layout_props.content_element != undefined

	if make_content_item {
		content_item = yui_make_render_instance(layout_props.content_element, data_source);
	}
	
	if content_item {
		// check if we need to rebuild
		content_item.rebuild = content_item.data_context != data_source;
		if content_item.rebuild {
			// update child data context
			content_item.data_context = data_source;
			// will trigger build() as child runs after this
		}
	}
}

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !visible {
		return sizeToDefault();
	}
	
	var padding = layout_props.padding;
	padded_rect = padding.apply(available_size, layout_props.size);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w < 0 || padded_rect.h < 0 {
		return sizeToDefault();
	}
	
	var desired_size = {
		w: 0,
		h: 0,
	}
	
	if content_item {
		is_arranging = true;
		var content_size = content_item.arrange(padded_rect, viewport_size);
		is_arranging = false;
		
		desired_size.w += content_size.w + padding.w;
		desired_size.h += content_size.h + padding.h;
	}

	var drawn_size = element_size.constrainDrawSize(available_size, desired_size);
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	// probably unnecessary but keeping for reference
	//if viewport_size {
	//	updateViewport();
	//}
	
	if events.on_arrange != undefined {
		yui_call_handler(events.on_arrange, [draw_size], data_source);
	}
	
	return draw_size;
}

onChildLayoutComplete = function(child) {
	if !is_arranging {
		arrange(draw_rect, viewport_size);
		if is_size_changed && parent {
			parent.onChildLayoutComplete(self);
		}
	}
}

base_traverse = traverse;
traverse = function(func, acc = undefined) {
	
	with self {
		// allow the traverse function to change the acc itself
		acc = func(acc) ?? acc;
	}
	
	if content_item && instance_exists(content_item) {
		content_item.traverse(func, acc);
	}
}

// override move
base_move = move;
move = function(xoffset, yoffset) {
	base_move(xoffset, yoffset);
	if content_item {
		content_item.move(xoffset, yoffset);
	}
}

base_unload = unload;
unload = function(unload_root = undefined) {
	var unload_time = base_unload(unload_root);
	
	if content_item && instance_exists(content_item) {
		unload_time = max(unload_time, content_item.unload(unload_root_item));
	}

	return unload_time;
}

Inspectron()
	.Section("yui_border")
	.FieldsSuffix("color", InspectronColor)