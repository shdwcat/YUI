/// @description init

event_inherited();

default_props = {};

// the YuiElement for this render object
yui_element = undefined;

// the index of this item within its parent's children, if any
item_index = undefined;

// the map of values that control layout;
layout_props = undefined;

// whether there are any UI values that are actively bound in a YuiScript expression
is_binding_active = true;

// the map of values that depend on the data context
bound_values = undefined;

opacity = 1;

// this only applies alpha for bg_color set on an element placed in the room editor
bg_alpha = ((bg_color & 0xFF000000) >> 24) / 255;

// whether this element is currently highlighted (e.g. button press)
highlight = false;

// the element that powers the tooltip item
tooltip_element = undefined;

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
	
	focusable = yui_element.props.focusable;
	
	// set initial focus if needed
	if focusable 
		&& ((YuiCursorManager.focused_item == undefined || !instance_exists(YuiCursorManager.focused_item))
			|| yui_element.props.autofocus) {
		YuiCursorManager.setFocus(id);
	}
	
	canvas = yui_element.canvas;
	tooltip_element = yui_element.tooltip_element;
	
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
		if visible {
			visible = false;
		
			// need to reset these, as values may change while the element
			// is not visible, which means the diffing will be out of date
			bound_values = undefined;
		}
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
	
	// maybe move this to element.is_live()?
	is_binding_active = bound_values.is_live;

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

findAncestor = function(type) {
	var ancestor = parent;
	while ancestor != undefined {
		if ancestor.yui_element.props._type == type {
			return ancestor;
		}
		ancestor = ancestor.parent;
	}
	throw yui_error("could not find ancestor with type " + type);
}

closePopup = function(close_parent = false) {
	var ancestor = parent;
	while ancestor != undefined {
		if ancestor.object_index == yui_popup_button {
			ancestor.closePopup(close_parent);
			return;
		}
		ancestor = ancestor.parent;
	}
}