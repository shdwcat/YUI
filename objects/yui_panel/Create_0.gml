/// @description init

// Inherit the parent event
event_inherited();

has_content_item = false;

layout = undefined;
internal_children = [];
is_arranging = false;
used_layout_size = undefined;

border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	layout = layout_props.layout;
}

border_build = build;
build = function yui_panel__build() {
	border_build();
	
	// resync our internal children to the bound children
	
	var child_count = bound_values.child_count;
	var display_count = layout_props.count
		? min(child_count, layout_props.count)
		: child_count;
	
	var previous_count = array_length(internal_children);
	var excess_count = previous_count - display_count;
	
	//if trace
	//	DEBUG_BREAK_YUI
	
	// resize the array if we need more room
	if display_count > previous_count {
		// TODO: this needs to cleanup the excess items or they will be orphaned
		array_resize(internal_children, display_count);
	}
	var i = 0; repeat display_count {
				
		var child = internal_children[i];
		var exists = child != 0;
		
		var data_index = layout_props.reverse ? child_count - i - 1 : i;
		
		if exists {
			// TODO: if the render item type doesn't match, we need to recreate
			// currently that's not possible so we won't worry about it
			var new_data = yui_element.uses_template
				? bound_values.data_items[data_index]
				: bound_values.data_items;
				
			// check if we need to rebuild
			child.rebuild = child.data_context != new_data;
			if child.rebuild {
				child.data_context = new_data;
			}
			//tracelog("replacing child at", i, old.id, "with", child.data_context.id);
		}
		else {
			if yui_element.uses_template {
				var item_element =  yui_element.item_element;
				var data = bound_values.data_items[data_index];
			}
			else {
				var item_element =  yui_element.item_elements[data_index];
				var data = bound_values.data_items;
			}
			
			// create the child render object
			var child = yui_make_render_instance(item_element, data, i);
			
			
			//tracelog("creating child at", i, child.data_context[$"id"], "id:", child.id);

			// track it in our internal children array
			internal_children[i] = child;
		}
		i++;
	}
	
	// clean up excess internal_children
	if excess_count > 0 {
		repeat excess_count {
			var excess_child = internal_children[i++];
			//tracelog("destroying excess child at", i, excess_child.data_context.id, "id: ", excess_child.id);
			excess_child.unload();
		}
		
		// resize the array to the new count
		array_resize(internal_children, display_count);
	}
}

/// @param {struct} available_size
/// @param {struct} viewport_size
arrange = function yui_panel__arrange(available_size, viewport_size) {
		
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	self.viewport_size = viewport_size;
	
	if !visible {
		return sizeToDefault();
	}
	
	//if trace {
	//	DEBUG_BREAK_YUI;
	//}
	
	var padding = layout_props.padding;
	padded_rect = padding.apply(available_size, layout_props.size);
	layout.init(internal_children, padded_rect, viewport_size, yui_element.props);

	is_arranging = true;
	used_layout_size = layout.arrange(bound_values);
	is_arranging = false;
	
	// our desired size is the layout's draw size with our padding
	var desired_size = {
		w: layout.draw_size.w + padding.w,
		h: layout.draw_size.h + padding.h,
	}
	
	var drawn_size = element_size.constrainDrawSize(available_size, desired_size);
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	// probably unnecessary but keeping for reference
	//if viewport_size {
	//	updateViewport();
	//}
	
	// our used size is the layout used size with our padding
	var used_size = {
		x: x,
		y: y,
		w: max(drawn_size.w, used_layout_size.w + padding.w),
		h: max(drawn_size.h, used_layout_size.h + padding.h),
	};
	
	if events.on_arrange != undefined {
		yui_call_handler(events.on_arrange, [used_size], data_source);
	}
	
	return used_size;
}

onChildLayoutComplete = function(child) {
	if !is_arranging {
		arrange(draw_rect, viewport_size);
		if is_size_changed && parent {
			parent.onChildLayoutComplete(self);
		}
	}
}

move = function(xoffset, yoffset) {
	// use base move, not border's move
	base_move(xoffset, yoffset);
	
	var i = 0; repeat array_length(internal_children) {
		internal_children[i++].move(xoffset, yoffset);
	}
	
	if used_layout_size {
		used_layout_size.x += xoffset;
		used_layout_size.y += yoffset;
	}
}

resize = function(width, height) {
	yui_resize_instance(width, height);
	layout.resize(width - layout_props.padding.w, height - layout_props.padding.h);
}

unload = function(unload_root = undefined) {
	// use base unload, not border's unload
	var unload_time = base_unload(unload_root);
	
	var i = 0; repeat array_length(internal_children) {
		var child_item = internal_children[i];
		//yui_log("unloading panel child (index ", i, ") visual", instance.id);
		
		var child_unload_time = child_item.unload(unload_root_item);
		
		unload_time = max(unload_time, child_unload_time);
		i++;
	}

	return unload_time;
}

Inspectron()
	.Section("yui_panel")
	.Include(nameof(layout))