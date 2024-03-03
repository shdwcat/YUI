/// @description 

// Inherit the parent event
event_inherited();

// where to position relative to viewport draw rect
viewport_x = 0;
viewport_y = 0;

// default to infinite content size
content_w = infinity;
content_h = infinity;

// info about viewport extents
viewport_info = {
	x_ratio: 0,
	y_ratio: 0,
	x_max: undefined,
	y_max: undefined,
}

border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	
	set_viewport_info = layout_props.on_viewport_info;
	
	// get viewport size override if defined
	if layout_props.content_w != undefined {
		content_w = layout_props.content_w;
	}
	if layout_props.content_h != undefined {
		content_h = layout_props.content_h;
	}
}

border_build = build;
build = function() {
	border_build();
	
	viewport_x = bound_values.viewport_x;
	viewport_y = bound_values.viewport_y;
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
	
	var actual_viewport_size = element_size.constrainDrawSize(available_size, {
		x: x,
		y: y,
		w: 0,
		h: 0,
		parent: viewport_size,
	});
	
	// arrange content using the specified content size
	var available_content_size = {
		x: x,
		y: y,
		w: content_w == "fit" ? actual_viewport_size.w : content_w,
		h: content_h == "fit" ? actual_viewport_size.h : content_h,
	}
	
	var content_size = undefined;
	if content_item {
		content_size = content_item.arrange(available_content_size, actual_viewport_size);
	}
	else {
		content_size = { x: x, y: y, w: 0, h: 0 };
	}
	
	var desired_size = {
		w: content_size.w,
		h: content_size.h,
	};
	
	var drawn_size = element_size.constrainDrawSize(available_size, desired_size);
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	// determine viewport bounds and position viewport content
	
	var viewport_x_max = max(0, content_size.w - drawn_size.w);
	var viewport_y_max = max(0, content_size.h - drawn_size.h);
	
	if content_item && (viewport_x != 0 || viewport_y != 0) {
		
		// clamp viewport x,y within the 'viewport area'
		var xoffset = clamp(viewport_x, 0, viewport_x_max);
		var yoffset = clamp(viewport_y, 0, viewport_y_max);
		
		content_item.move(-xoffset, -yoffset);
	}
	
	// push viewport info back to game layer if requested
	if set_viewport_info != undefined {
		viewport_info.x_max = viewport_x_max;
		viewport_info.y_max = viewport_y_max;
		viewport_info.x_ratio = viewport_x / viewport_x_max;
		viewport_info.y_ratio = viewport_y / viewport_y_max;
		viewport_info.viewport_w = draw_size.w;
		viewport_info.viewport_h = draw_size.h;
		yui_call_handler(set_viewport_info, [viewport_info], data_source);
	}
	
	return draw_size;
}

border_move = move;
move = function(xoffset, yoffset) {
	if content_item {
		content_item.viewport_size.x += xoffset;
		content_item.viewport_size.y += yoffset;
	}
	
	border_move(xoffset, yoffset);
}