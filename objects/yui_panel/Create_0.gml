/// @description init

// Inherit the parent event
event_inherited();

has_content_item = false;

recycling = false;
recycling_lookup = undefined;

layout = undefined;
internal_children = [];
is_arranging = false;
used_layout_size = undefined;

destroy = function() {
	var i = 0; repeat array_length(internal_children) {
		var child = internal_children[i++];
		if instance_exists(child)
			child.destroy();
	}
		
	// use base_destroy not border_destroy		
	base_destroy();
}

border_onLayoutInit = onLayoutInit;
onLayoutInit = function() {
	border_onLayoutInit();
	layout = layout_props.layout;
	recycling = layout_props.recycling;
	recycling_lookup = ds_map_create();
}

logChildrenData = function(show_index) {
	var datas = show_index
		? array_map(internal_children, function(i, index) {
			return  $"{i.data_context} idx:{i.item_index}";
		})
		: array_map(internal_children, function(i, index) {
			return i.data_context;
		});
	yui_log($"internal children data: {datas}")
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
	//	yui_break();
	
	if yui_element.uses_template && recycling {
		
		// add case - just build a new item for anything not found
		// data [1, 2, A, 4, 5]
		// elem [1, 2, 4, 5]
		
		// remove case - find the existing item for the data and swap
		// (so that existing item gets cleaned up later if not re-used)
		// data [1, 2, 3, 4]
		// elem [1, 2, A, 3, 4]
		
		// swap case - swapping works fine because existing items have been preserved in the recycling_lookup
		// data [1, 2, A, B]
		// elem [1, 2, B, A]
		
		// map the previous children by their data_context
		ds_map_clear(recycling_lookup);
		var i = 0; repeat previous_count {
			var child = internal_children[i++];
			var child_data = child.data_context;
			if child_data == undefined
				continue;
			
			// maybe it's okay to just continue here? or somehow include an index
			if ds_map_exists(recycling_lookup, child_data)
				throw yui_error("Panel recycling mode is only supported for data sets where all items are unique");
				
			recycling_lookup[? child_data] = child;
		}
		
		if trace {
			yui_log("--- before update ---");
			yui_log($"data items: {bound_values.data_items}");
			logChildrenData();
			yui_log("---");
		}
		
		// now loop through, and try to match to existing items by data
		var item_element = yui_element.item_element;
		var data_items = bound_values.data_items;
		var insertion_count = 0;
		var i = 0; repeat display_count {
			var data_index = layout_props.reverse ? child_count - i - 1 : i;
			var new_data = data_items[data_index];
			
			var item_at_index = data_index < (previous_count + insertion_count)
				? internal_children[data_index]
				: undefined;
			var item_for_data = recycling_lookup[? new_data];
			
			if item_for_data == undefined {
				// no match, insert new item
			
				// create the child render object
				var child = yui_make_render_instance(item_element, new_data, i);
				
				if trace
					yui_log($"{i} - inserted item {new_data} at position {i}");

				// insert it in our internal children array
				array_insert(internal_children, i, child);
				excess_count += 1;
				insertion_count += 1;
				
				if trace
					logChildrenData();
			}
			else if item_for_data != item_at_index {
				// found match at wrong index, swap with the correct item
				
				var item_for_data_index = item_for_data.item_index + insertion_count;
				
				if item_at_index == undefined
					yui_break();
				
				if trace
					yui_log($"{i} - swapping correct item {new_data} at position {item_for_data_index} with item [item_at_index.data_context] at position {i}");
				
				// move the old item to the correct item's previous position
				internal_children[item_for_data_index] = item_at_index;
				item_at_index.item_index = item_for_data_index;
				
				// put the correct item in this place
				internal_children[i] = item_for_data;
				item_for_data.item_index = i;
				
				if trace
					logChildrenData();
			}
			else {
				// correctly placed but might need item index update if something was inserted before
				item_at_index.item_index = i;
				
				if trace
					yui_log($"{i} - no swap needed");
			}
			i++;
		}
	}
	else {
		// resize the array if we need more room
		if display_count > previous_count {
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

				// track it in our internal children array
				internal_children[i] = child;
			}
			i++;
		}
	}
	
	// clean up excess internal_children
	if excess_count > 0 {
		repeat excess_count {
			var excess_child = internal_children[i++];
			//yui_log($"disposed excess_child ({excess_child.data_context}) {excess_child.id}");
			excess_child.unload();
		}
		
		// resize the array to the new count
		array_resize(internal_children, display_count);
	}
	
	//if trace && recycling {
	//	yui_log("");
	//	logChildrenData(true);
	//	yui_log("=======================");
	//	yui_log("");
	//}
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
	//	yui_break();
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

base_traverse = traverse;
traverse = function(func, acc = undefined) {
	
	with self {
		// allow the traverse function to change the acc itself
		acc = func(acc) ?? acc;
	}
	
	var i = 0; repeat array_length(internal_children) {
		var child = internal_children[i++];
		if instance_exists(child) {
			child.traverse(func, acc);
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
		
		if instance_exists(child_item) {
			var child_unload_time = child_item.unload(unload_root_item);
			unload_time = max(unload_time, child_unload_time);
		}
		
		i++;
	}

	return unload_time;
}

Inspectron()
	.Section("yui_panel")
	.Include(nameof(layout))