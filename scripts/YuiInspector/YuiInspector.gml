/// @desc manages a debug overlay for inspecting YUI items
function YuiInspector() constructor {
		
	target = undefined;
	target_list = [];
	
	debug_pointer = undefined;
	
	pick_index = 0;
	
	current = {
		pick_index: 0,
	}
	
	static refresh = function() {
		
		if array_length(target_list) <= pick_index or !instance_exists(target_list[pick_index])
			dbg_view_delete(debug_pointer);
		
		var needs_refresh =
			pick_index != current.pick_index;
		
		if needs_refresh show(target_list, true);
	}
	
	/// @param {Array<id.instance>} render_items
	function show(render_items, force = false) {
		var new_target = array_first(render_items);	
		if force || new_target != target {		
			target = new_target;
			target_list = render_items;
			
			current = {
				pick_index,
			};
		
			if debug_pointer {
				dbg_view_delete(debug_pointer);
			}
			
			var window_rect = InspectronCalcOverlayRect(target);

			debug_pointer = dbg_view(
				$"YUI - {target._id}", true,
				window_rect.x, window_rect.y, window_rect.w, window_rect.h);
			
			dbg_section($"General");
						
			InspectronArrayDropDown(
				ref_create(self, "pick_index"),
				$"Instances at {mouse_x}, {mouse_y}",
				target_list,
				function (item) { return item._id; });	
			
			// render whichever item was picked
			var pick = target_list[pick_index];
			pick.inspectron.render();
		}
	}
}