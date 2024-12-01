/// @description bind / layout

if layout_props == undefined {
	// Feather disable once GM1021
	yui_element ??= new element_constructor(default_props, {});
	// feather disable GM2016
	initLayout();
	// feather restore GM2016
}

// ensure invisible items destroy themselves since they won't run the Pre-Draw event
if !visible && unload_now {
	instance_destroy();
	return;
}

// hide self if marked hidden, or parent is not visible
// (depth order ensures further children will get hidden in the same frame)
if hidden || parent && !parent.visible {
	hideElement();
	exit;
}

if trace
	DEBUG_BREAK_YUI;
	
// NOTE: if an item has no bindings to trigger rebuild, it will never do initial arrange
// this can cause problems with panels that should be clipped out of a parent panel
// as the children will never get arranged and sized to 0 for being clipped
// need to figure out how to fix this...

var was_visible = visible

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
		
		if on_arrange_anim
			beginAnimationGroup(on_arrange_anim);
	}
}
	
if visible {
	process(!was_visible);
}


