/// @description 

// Inherit the parent event
event_inherited();

onLayoutInit = function() {
	draw_to_world = layout_props.draw_to_world;
}

build = function() {
	color = bound_values.color;
	width = bound_values.width;
	x1 = bound_values.x1;
	y1 = bound_values.y1;
	x2 = bound_values.x2;
	y2 = bound_values.y2;
}

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	// doesn't take up any size
	yui_resize_instance(0, 0);
}