/// @desc manages a debug overlay for inspecting YUI items
function YuiInspector() constructor {
		
	target = undefined;
	target_list = undefined;
	debug_pointer = undefined;
	
	w = 700;
	h = 550;
	
	show_parents = false;
	
	current = {
		show_parents: false,
	}
	
	static refresh = function() {
		var needs_refresh = show_parents != current.show_parents;
		
		if needs_refresh show(target_list, true);
	}
	
	/// @param {Array<id.instance>} render_items
	function show(render_items, force = false) {		              
		var new_target = array_first(render_items);	
		if force || new_target != target {		
			target = new_target;
			target_list = render_items;
			
			current = {
				show_parents: show_parents,
			};
		
			if debug_pointer {
				dbg_view_delete(debug_pointer);
			}
			
			var max_x = display_get_width() - w;
			var max_y = display_get_height() - h;
		
			debug_pointer = dbg_view(
				"YUI - " + target._id, true,
				min(max_x, target.x + target.draw_size.w + 5),
				min(max_y, target.y),
				w, h);
			
			dbg_section("Options");
			dbg_checkbox(ref_create(self, "show_parents"), "Show Parents?");
			dbg_checkbox(ref_create(self, "show_bindings"), "show_bindings?");
					
			var count = array_length(render_items);
			var i = 0; repeat count {
				var item = render_items[i++];
				
				if i == 2 && show_parents
					dbg_text("=== Parents ===");
				
				dbg_section(item._id);
				item.inspectron.render();
				
				if (!show_parents) break;
			}		
		}
	}
}