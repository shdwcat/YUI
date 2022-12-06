/// @description bind / layout

if layout_props == undefined {
	yui_element ??= new element_constructor(default_props, {});
	initLayout();
}

// hide self if marked hidden, or parent is not visible
// (depth order ensures further children will get hidden in the same frame)
if hidden || parent && !parent.visible {
	visible = false;
	rebuild = false;
	exit;
}

if trace
	DEBUG_BREAK_YUI;

// NOTE: this will be false if no bindings are live
if is_binding_active || !visible || rebuild {

	// check if any bindings require rebuilding UI state
	rebuild = bind_values();

	if rebuild {
		build();
	
		// way to detect if build() requires re-arrange?
		// have build return a boolean
		arrange(draw_rect, viewport_size);
	
		// only update parent if our size actually changed
		if is_size_changed && parent {
			parent.onChildLayoutComplete(self);
		}
	}
}
	
if visible {
	opacity_value.update(data_source, current_time);
		
	var old_opacity = opacity;
	
	// gotta update this every frame since it could be animated, including from the parent!
	opacity = opacity_value.value * (parent ? parent.opacity : 1) * (1 - (!enabled * 0.5))
	
	// referenced by anything that needs to rebuild when opacity changes (e.g. text element)
	opacity_changed = opacity != old_opacity;
}


