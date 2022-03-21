/// @description init

// Inherit the parent event
event_inherited();

default_props = {
	type: "border",
	//trace: true,
	content: "This is a test! Big Test! This is a test! Big Test!This is a test! Big Test!This is a test! Big Test!",
}

has_content_item = true; // yui_panel sets this to false
content_item = undefined;

onLayoutInit = function() {
}

build = function() {
	trace = yui_element.props.trace; // hack
	
	opacity = bound_values.opacity * parent.opacity;
	
	// create the content item instance if there should be one
	// NOTE: have to do this after opacity
	var make_content_item = 
		has_content_item
		&& content_item == undefined
		&& layout_props.content_element != undefined
		
	if make_content_item {
		content_item = yui_make_render_instance(layout_props.content_element, data_context);
	}
	
	if bound_values.bg_color != undefined {
		bg_color = bound_values.bg_color;
		bg_alpha = ((bg_color & 0xFF000000) >> 24) / 255;
	}
	if bound_values.border_color != undefined {
		border_color = bound_values.border_color;
	}
	if bound_values.border_thickness != undefined {
		border_thickness = bound_values.border_thickness;
	}
	if bound_values.bg_sprite != undefined {
		bg_sprite = bound_values.bg_sprite;
		bg_alpha = 1;
	}
	
	if border_color != undefined {
		border_alpha = ((border_color & 0xFF000000) >> 24) / 255;
	}
	
	if content_item {
		content_item.data_context = bound_values.data_source;
		// will trigger build() as child runs after this
	}
}

arrange  = function(available_size) {
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	
	var padding = layout_props.padding;
	padded_rect = yui_apply_padding(available_size, padding, layout_props.size);
	
	// don't bother drawing if there isn't enough room
	if padded_rect.w < 0 || padded_rect.h < 0 {
		yui_resize_instance(0, 0);
		return draw_size;
	}
	
	var content_size = undefined;
	if content_item {
		content_size = content_item.arrange(padded_rect);
	}
	else {
		content_size = { x: padded_rect.x, y: padded_rect.y, w: 0, h: 0 };
	}

	var drawn_size = yui_apply_element_size(layout_props.size, available_size, {
		w: content_size ? content_size.w + padding.w : 0,
		h: content_size ? content_size.h + padding.h : 0,
	});
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	if bound_values.xoffset != 0 || bound_values.yoffset != 0 {
		move(bound_values.xoffset, bound_values.yoffset);
	}
	
	return draw_size;
}

onChildLayoutComplete = function(child) {
	arrange(draw_rect);
	if parent {
		parent.onChildLayoutComplete(self);
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
	