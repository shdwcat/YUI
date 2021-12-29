/// @description init

event_inherited();

default_props = {};

// the YuiRenderer for this render object
yui_element = undefined;

// the index of this item within its parent's children, if any
item_index = undefined;

// the map of values that control layout;
layout_props = undefined;

// the map of values that depend on the data context
bound_values = undefined;

// this only applies alpha for bg_color set on an element placed in the room editor
bg_alpha = ((bg_color & 0xFF000000) >> 24) / 255;

// whether this element is currently highlighted (e.g. button press)
highlight = false;

// the renderer that powers the tooltip item
tooltip_renderer = undefined;

// the actual render object for the tooltip when it's visible
tooltip_item = undefined;

// the space we were given to draw in
draw_rect = {
	x: x,
	y: y,
	w: bbox_right - bbox_left,
	h: bbox_bottom - bbox_top,
};

// the space we actually drew in
draw_size = {
	x: x,
	y: y,
	w: bbox_right - bbox_left,
	h: bbox_bottom - bbox_top,
};

padded_rect = { x: x, y: y, w: 0, h: 0 };

initLayout = function() {
	layout_props = yui_element.getLayoutProps();
	
	canvas = yui_element.canvas;
	tooltip_renderer = yui_element.tooltip_renderer;
	
	events = yui_element.props.events;
	yui_register_events(events);
	
	interactions = yui_element.props.interactions;
	yui_register_interactions(interactions);
	
	onLayoutInit();
}

onLayoutInit = function() {
	// virtual
}

bind_values = function() {
	var new_values = yui_element.getBoundValues(data_context, bound_values)
	if new_values == false {
		visible = false;
		exit;
	}
	else if new_values == true {
		// values are the same as before, nothing to do
		exit;
	}
	else {
		visible = true;
	}

	bound_values = new_values;
	return true;
}

build = function() {
	throw "build not implemented on this type";
}

arrange = function(available_size) {
	throw "arrange not implemented on this type";
}

move = function(xoffset, yoffset) {
	x += xoffset;
	draw_size.x += xoffset;
	padded_rect.x += xoffset;
	y += yoffset;
	draw_size.y += yoffset;
	padded_rect.y += yoffset;
	
	// move tooltip?
	
	if interaction_item {
		interaction_item.move(xoffset, yoffset);
	}
}

cursor_tooltip = function() {
	//var tooltip = yui_resolve_binding(
}
