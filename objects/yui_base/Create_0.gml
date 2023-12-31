/// @description init

event_inherited();

default_props = {};

// the YuiElement for this render object
yui_element ??= undefined;

// the index of this item within its parent's children, if any
item_index ??= undefined;

// whether we need to rebuild due to data changes
rebuild = false;

// the map of values that control layout;
layout_props = undefined;

// whether there are any UI values that are actively bound in a YuiScript expression
is_binding_active = true;

// the resolved data_source after element.data_source has been resolved
data_source = undefined;

// the map of values that depend on the data context
bound_values = undefined;

enabled = true;
hidden = false;

// whether this item is in the process of unloading (e.g. playing unload animation)
unloading = false;

// whether this item is finished unloading and should be destroyed
unload_now = false;

// if any part of a tree has an unloading animation, the unload_root_item for a given
// element will be the topmost item that has one (which may be itself)
// NOTE: this is because the children can't destroy themselves until all unload
// animations within the unload_root_item tree have finished animating
unload_root_item = undefined;

// default to false so that first load triggers on_visible
visible = false;

// defaulting to 0 allows animations to control fade in before opacity gets calculated
// (this mostly matters with yui_change_screen which can rebuild the UI outside of the
// normal event order logic)
opacity = 0;

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

// offsets from the measured position, used in animation, etc
xoffset = 0;
yoffset = 0;

is_size_changed = false;

padded_rect = { x: x, y: y, w: 0, h: 0 };

// if defined, the size of the viewport containing this element
viewport_size = undefined;

// the part of this element that is visible within the viewport
viewport_part = undefined;

// hack so that text element knows to rebuild
opacity_changed = false;

initLayout = function() {
	_id = yui_element.props.id;
	trace = yui_element.props.trace;
	
	element_size = yui_element.size;
	canvas = yui_element.canvas;
	flex = yui_element.flex;
	has_tooltip = yui_element.props.tooltip != undefined;
	
	events = yui_element.props.events;
	yui_register_events(events);
	
	interactions = yui_element.props.interactions;
	yui_register_interactions(interactions);
	
	focusable = yui_element.props.focusable;
	is_cursor_layer = yui_element.props.is_cursor_layer;
	
	// TODO: this bypasses enabled, should probably move to first build
	// set initial focus if needed
	if focusable 
		&& ((YuiCursorManager.focused_item == undefined || !instance_exists(YuiCursorManager.focused_item))
			|| yui_element.props.autofocus) {
		YuiCursorManager.setFocus(id);
	}
	
	// any data_source value means we have to evaluate it 
	has_data_source = yui_element.data_source != undefined;
	
	data_source_value = new YuiBindableValue(yui_element.data_source);
	enabled_value = new YuiBindableValue(yui_element.props.enabled);
	visible_value = new YuiBindableValue(yui_element.props.visible);
	opacity_value = new YuiBindableValue(yui_element.props.opacity);
	xoffset_value = new YuiBindableValue(yui_element.props.xoffset);
	yoffset_value = new YuiBindableValue(yui_element.props.yoffset);
	
	// map of animatable properties to the YuiBindableValues
	animatable = {
		opacity: opacity_value,
		visible: visible_value,
		xoffset: xoffset_value,
		yoffset: yoffset_value,
	};
	
	if !enabled_value.is_live enabled = yui_element.props.enabled;
	
	on_visible_anim = yui_element.on_visible_anim;
	on_arrange_anim = yui_element.on_arrange_anim;
	on_unloading_anim = yui_element.on_unloading_anim;
	
	layout_props = yui_element.getLayoutProps();
	onLayoutInit();
}

onLayoutInit = function() {
	// virtual
}

hide_element = function() {
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
}

bind_values = function yui_base__bind_values() {
	var data_source_changed = false;
	if has_data_source {
		data_source_changed = data_source_value.update(data_context);
		data_source = data_source_value.value;
	}
	else {
		data_source = data_context;
	}
	
	if visible_value.is_live visible_value.update(data_source);
	if visible_value.value == false {
		hide_element();
		exit;
	}
	
	// get new values
	var new_values = yui_element.getBoundValues(data_source, bound_values)
	
	// handle custom cases where we might want to not be visible 
	// e.g. text element text is undefined
	if new_values == false {
		hide_element();
		exit;
	}
	
	// ensure that we're now visible
	var was_visible = visible;
	visible = true;
	
	if !was_visible {
		if on_visible_anim
			beginAnimationGroup(on_visible_anim);
	}
		
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
	throw "build() not implemented on this type!";
}

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function(available_size, viewport_size) {
	throw "arrange() not implemented on this type!";
}

process = function yui_base__process() {
	
	// calculate enabled state from parent and/or live value
	
	var is_parent_enabled = parent ? parent.enabled : true;
	
	if is_parent_enabled && enabled_value.is_live {
		enabled_value.update(data_source);
		enabled = enabled_value.value;
	}
	else {
		enabled = is_parent_enabled;
	}
	
	// update focusable state
	
	focusable = enabled ? yui_element.props.focusable : false;
	if focused && !focusable {
		YuiCursorManager.clearFocus();
	}
	
	// update opacity
	
	if opacity_value.is_live opacity_value.update(data_source);
		
	var old_opacity = opacity;
	
	// update opacity every frame since it could be animated, including from the parent!
	opacity = opacity_value.value * (parent ? parent.opacity : 1) * (1 - (!enabled * 0.5))
	
	// referenced by anything that needs to rebuild when opacity changes (e.g. text element)
	opacity_changed = opacity != old_opacity;
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
			
	viewport_part = yui_trim_rect_to_viewport(x, y, draw_size.w, draw_size.h, vp_size);
}

resize = yui_resize_instance;

sizeToDefault = function() {
	var w = min(element_size.default_w, draw_rect.w);
	var h = min(element_size.default_h, draw_rect.h);
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
					data_source, 
					/* no index */,
					1000); // ensures tooltips appear above popup layers
	
				var popup_space = yui_calc_popup_space(tooltip_item.bound_values.placement, draw_size);
				tooltip_item.arrange(popup_space);
			}
		}
		else if tooltip_item != undefined {
			tooltip_item.unload();
			tooltip_item = undefined;
		}
	}
}

// NOTE: assumes the point has already been tested via something like instance_position()
isPointVisible = function(x, y) {
	if viewport_part != undefined && viewport_part.clipped {
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

beginAnimationGroup = function(animation_group) {
	if animation_group.enabled
		animation_group.start(animatable, self);
}

unload = function(unload_root = undefined) {
	
	unloading = true;
	
	// TODO: call on_unloading element event
	
	// if we're not visible, set unload_now and return zero immediately
	if !visible {
		unload_now = true;
		return 0;
	}
	
	// if there isn't already an unload root and this has an unload anim, this is the root
	if unload_root == undefined and on_unloading_anim != undefined {
		unload_root = self;
	}
	
	// track the unload root item
	unload_root_item ??= unload_root;
	
	// the unload time will be the max of our unload animation duration and any of our child items
	var unload_time = 0;
	if on_unloading_anim {
		// need to call init in order to force bound duration to calc
		on_unloading_anim.init(data_source);
		unload_time = on_unloading_anim.duration;
	}
	if tooltip_item {
		unload_time = max(unload_time, tooltip_item.unload(unload_root));
	}
	
	// if there is no unload root and unload time is zero we can just mark unloaded now
	if unload_time == 0 and unload_root == undefined {
		unload_now = true;
		return 0;
	}
	
	// start the unloading anim
	if on_unloading_anim {
		beginAnimationGroup(on_unloading_anim);
	}
	
	// if we're the unload root, set the timer to destroy ourselves at the end of the unload time
	if unload_root == self {
		with {} {
			root = unload_root;
			call_later(unload_time / 1000, time_source_units_seconds, function () {
				root.unload_now = true;	
			})
		}
	}
	
	return unload_time;
}

Inspectron()
	.Header("yui_base")
	.Checkbox(nameof(trace))
	.Checkbox(nameof(is_cursor_layer))
	.Watch(nameof(enabled))
	.Watch(nameof(focusable))
	.Watch(nameof(opacity))
	.Watch(nameof(xoffset))
	.Watch(nameof(yoffset))
	.Rect(nameof(draw_size))
	.Rect(nameof(draw_rect))
	.Rect(nameof(viewport_size))
	.Rect(nameof(viewport_part))
	.FieldsSuffix("color", InspectronColor, nameof(layout_props))
	.FieldsSuffix("sprite", InspectronSprite, nameof(layout_props))
	