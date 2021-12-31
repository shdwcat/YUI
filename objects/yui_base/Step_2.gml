/// @description bind / layout

if layout_props == undefined {
	if yui_element == undefined {
		yui_element = new element_constructor(default_props, {});
	}
	initLayout();
}

// hide self if parent is not visible
// (depth order ensures further children will get hidden in the same frame)
if parent && !parent.visible {
	visible = false;
	rebuild = false;
	exit;
}

// NOTE: this will be false if no bindings are live
if is_binding_active {

	// check if any bindings require rebuilding UI state
	rebuild = bind_values();

	if rebuild {
		build();
	
		// way to detect if build() requires re-arrange?
		// have build return a boolean
		arrange(draw_rect);
	
		if parent {
			parent.onChildLayoutComplete(self);
		}
	}
}

// create/destroy tooltip item
// TODO?: handle this in setHighlight() to avoid the per frame hit
if tooltip_element {
	if highlight {
		if tooltip_item == undefined {	
			tooltip_item = yui_make_render_instance(
				tooltip_element,
				bound_values.data_source, 
				/* no index */,
				1000); // ensures tooltips appear above popup layers
	
			var popup_space = yui_calc_popup_space(tooltip_item);
			tooltip_item.arrange(popup_space);
		}
	}
	else if tooltip_item != undefined {
		instance_destroy(tooltip_item);
		tooltip_item = undefined;
	}
}