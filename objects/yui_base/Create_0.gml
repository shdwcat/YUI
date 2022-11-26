/// @description init

event_inherited();

default_props = {};

// the YuiElement for this render object
yui_element = undefined;

// whether we need to rebuild due to data changes
rebuild = false;

// the index of this item within its parent's children, if any
item_index = undefined;

// the map of values that control layout;
layout_props = undefined;

// whether there are any UI values that are actively bound in a YuiScript expression
is_binding_active = true;

// the map of values that depend on the data context
bound_values = undefined;

enabled = true;
hidden = false;
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

is_size_changed = false;

padded_rect = { x: x, y: y, w: 0, h: 0 };

// if defined, the size of the viewport containing this element
viewport_size = undefined;

// the part of this element that is visible within the viewport
viewport_part = undefined;

initLayout = function() {
	_id = yui_element.props.id;
	
	default_w = yui_element.size.default_w;
	default_h = yui_element.size.default_h;
	canvas = yui_element.canvas;
	flex = yui_element.flex;
	has_tooltip = yui_element.props.tooltip != undefined;
	
	events = yui_element.props.events;
	yui_register_events(events);
	
	interactions = yui_element.props.interactions;
	yui_register_interactions(interactions);
	
	focusable = yui_element.props.focusable;
	is_cursor_layer = yui_element.props.is_cursor_layer;
	
	// set initial focus if needed
	if focusable 
		&& ((YuiCursorManager.focused_item == undefined || !instance_exists(YuiCursorManager.focused_item))
			|| yui_element.props.autofocus) {
		YuiCursorManager.setFocus(id);
	}
	
	layout_props = yui_element.getLayoutProps();
	onLayoutInit();
}

onLayoutInit = function() {
	// virtual
}

bind_values = function yui_base__bind_values() {
	var new_values = yui_element.getBoundValues(data_context, bound_values)
	if new_values == false {
		if visible {
			visible = false;
			
			if focused {
				YuiCursorManager.clearFocus();
			}
			
			// trigger parent re-layout since we might have been taking up space
			if parent and bound_values {
				parent.onChildLayoutComplete(self);
			}
		
			// need to reset these, as values may change while the element
			// is not visible, which means the diffing will be out of date
			bound_values = undefined;
		}
		exit;
	}
	
	// ensure that we're now visible
	var was_visible = visible;
	visible = true;
		
	// if bound values are same as before exit early
	if new_values == true {
		if was_visible {
			// values are the same as before, nothing to do
			exit;
		}
	}
	else {
		bound_values = new_values;
	}
	
	// maybe move this to element.is_live()?
	is_binding_active = bound_values.is_live;

	return true;
}

build = function() {
	throw "build not implemented on this type";
}

arrange = function(available_size, viewport_size) {
	throw "arrange not implemented on this type";
}

move = function(xoffset, yoffset) {
	x += xoffset;
	draw_size.x += xoffset;
	//draw_rect.x += xoffset;
	padded_rect.x += xoffset;
	y += yoffset;
	draw_size.y += yoffset;
	//draw_rect.y += yoffset;
	padded_rect.y += yoffset;
	
	if viewport_size {
		updateViewport();
	}
	
	
	if tooltip_item {
		tooltip_item.move(xoffset, yoffset);
	}
	
	if interaction_item {
		interaction_item.move(xoffset, yoffset);
	}
}

updateViewport = function() {
	
	// if our viewport has a parent, trim it within the parent
	var vp_size = viewport_size.parent
		? yui_trim_rect_to_viewport(
			viewport_size.x, viewport_size.y,
			viewport_size.w, viewport_size.h,
			viewport_size.parent)
		: viewport_size;
			
	viewport_part =	yui_trim_rect_to_viewport(x, y, draw_size.w, draw_size.h, vp_size);
}

resize = yui_resize_instance;

sizeToDefault = function(available_size) {
	var w = min(default_w, available_size.w);
	var h = min(default_h, available_size.h);
	yui_resize_instance(w, h);
	return draw_size;
}

findAncestor = function(type) {
	var ancestor = parent;
	while ancestor != undefined {
		if ancestor.yui_element.yui_type == type {
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
base_setHighlight = setHighlight;
setHighlight = function(highlight) {
	
	base_setHighlight(highlight)
	
	if has_tooltip {
		if highlight {
			tooltip_element ??= yui_element.createTooltip();
			if tooltip_item == undefined {
				tooltip_item = yui_make_render_instance(
					tooltip_element,
					bound_values.data_source, 
					/* no index */,
					1000); // ensures tooltips appear above popup layers
	
				var popup_space = yui_calc_popup_space(tooltip_item.bound_values.placement, draw_size);
				tooltip_item.arrange(popup_space);
			}
		}
		else if tooltip_item != undefined {
			instance_destroy(tooltip_item);
			tooltip_item = undefined;
		}
	}
}

// NOTE: assumes the point has already been tested via something like instance_position()
isPointVisible = function(x, y) {
	if viewport_part != undefined {
		return point_in_rectangle(
				x, y,
				viewport_part.x,
				viewport_part.y,
				viewport_part.x + viewport_part.w,
				viewport_part.y + viewport_part.h);
	}
	else {
		return visible;
	}
}








