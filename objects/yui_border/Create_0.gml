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

draw_border = false;

onLayoutInit = function() {	
		
	if layout_props.bg_color != undefined {
		bg_color = layout_props.bg_color;
		bg_alpha = ((bg_color & 0xFF000000) >> 24) / 255;
	}
	if layout_props.border_color != undefined {
		border_color = layout_props.border_color;
	}
	if layout_props.border_thickness != undefined {
		border_thickness = layout_props.border_thickness;
	}
	if layout_props.bg_sprite != undefined {
		bg_sprite = layout_props.bg_sprite;
		bg_alpha = 1;
	}
	
	is_bg_sprite_live = yui_element.is_bg_sprite_live;
	if is_bg_sprite_live
		bg_sprite_value = new YuiBindableValue(yui_element.bg_sprite_binding);
		
	is_bg_color_live = yui_element.is_bg_color_live;
	if is_bg_color_live
		bg_color_value = new YuiBindableValue(yui_element.bg_color_binding);
	
	border_focus_color = layout_props.border_focus_color ?? border_color;
	
	if border_color != undefined {
		border_alpha = ((border_color & 0xFF000000) >> 24) / 255;
	}
	
	draw_border =
		border_thickness > 0 && border_alpha > 0
		&& (border_color > 0 || border_focus_color > 0);
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
	
	if content_item {
		unload_time = max(unload_time, content_item.unload(unload_root_item));
	}

	return unload_time;
}

Inspectron()
	.Header("yui_border")
	.FieldsSuffix("color", InspectronColor)