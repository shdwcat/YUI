/// @description init

// Inherit the parent event
event_inherited();

has_content_item = false;

internal_children = [];
is_arranging = false;
used_layout_size = undefined;

onLayoutInit = function() {
	layout = layout_props.layout;
}

border_build = build;
build = function() {
	border_build();
	
	trace = yui_element.props.trace; // hack
	
	// resync our internal children to the bound children
	
	var previous_count = array_length(internal_children);	
	var excess_count = previous_count - bound_values.child_count;
	
	// resize the array if we need more room
	if bound_values.child_count > previous_count {
		array_resize(internal_children, bound_values.child_count);
	}
	
	var i = 0; repeat bound_values.child_count {
				
		var child = internal_children[i];
		var exists = child != 0;
		
		if exists {
			// TODO: if the render item doesn't match, we need to recreate
			// currently that's not possible so we won't worry about it
			child.data_context = bound_values.data_items[i];
		}
		else {
			var item_element = bound_values.item_elements[i];
			var data = bound_values.data_items[i]
			
			// create the child render object
			var child = yui_make_render_instance(item_element, data, i);

			// track it in our internal children array
			internal_children[i] = child;
		}
		i++;
	}
	
	// clean up excess internal_children
	if excess_count > 0 {
		repeat excess_count {
			var excess_child = internal_children[i++];
			instance_destroy(excess_child);
		}
		
		// resize the array to the new count
		array_resize(internal_children, bound_values.child_count);
	}
}

arrange = function(available_size) {
		
	x = available_size.x;
	y = available_size.y;
	draw_rect = available_size;
	
	var padding = layout_props.padding;
	padded_rect = yui_apply_padding(available_size, padding, layout_props.size);
	layout.init(internal_children, padded_rect, yui_element.props);
	
	is_arranging = true;
	used_layout_size = layout.arrange(bound_values.data_source);
	is_arranging = false;
	
	// update our draw size to encompass the layout's draw size with our padding
	var drawn_size = yui_apply_element_size(layout_props.size, available_size, {
		w: layout.draw_size.w + padding.w,
		h: layout.draw_size.h + padding.h,
	});
	
	yui_resize_instance(drawn_size.w, drawn_size.h);
	
	// our used size is the layout used size with our padding
	var used_size = {
		x: available_size.x,
		y: available_size.y,
		w: max(drawn_size.w, used_layout_size.w + padding.w),
		h: max(drawn_size.h, used_layout_size.h + padding.h),
	};
	return used_size;
}

onChildLayoutComplete = function(child) {
	if !is_arranging {
		arrange(draw_rect);
		if parent {
			parent.onChildLayoutComplete(self);
		}
	}
}

move = function(xoffset, yoffset) {
	base_move(xoffset, yoffset);
	
	var i = 0; repeat array_length(internal_children) {
		internal_children[i++].move(xoffset, yoffset);
	}
	
	if used_layout_size {
		used_layout_size.x += xoffset;
		used_layout_size.y += yoffset;
	}
}