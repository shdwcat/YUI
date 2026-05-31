/// @description 

// Inherit the parent event
event_inherited();

onLayoutInit = function() {
	draw_to_world = layout_props.draw_to_world;
	use_cleanshapes = layout_props.use_cleanshapes;
}

build = function() {
	color = bound_values.color;
	color_end = bound_values.color_end;
	width = bound_values.width;
	x1 = bound_values.x1;
	y1 = bound_values.y1;
	x2 = bound_values.x2;
	y2 = bound_values.y2;
	
	if use_cleanshapes {
		clean_line = CleanLine(x1, y1, x2, y2)
			.Thickness(width)
			.Blend2(color, bound_values.alpha, color_end, bound_values.alpha_end)
			.Cap(bound_values.cap, bound_values.cap_end);
	}
}

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	// doesn't take up any size
	yui_resize_instance(0, 0);
}