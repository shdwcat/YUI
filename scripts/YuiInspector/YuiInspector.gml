/// @desc manages a debug overlay for inspecting YUI items
function YuiInspector() constructor {
		
	target = undefined;
	target_list = undefined;
	debug_pointer = undefined;
	
	w = 700;
	h = 550;
	
	pick_index = 0;
	search = "";
	
	current = {
		pick_index: 0,
	}
	
	static refresh = function() {
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
				pick_index: pick_index,
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
			
			dbg_section("General");
						
			InspectronArrayDropDown(ref_create(self, "pick_index"), "Elements (click to select target)", target_list, function (item) {
				return item._id;
			});	
			
			var f = function() {
				yui_log("clicked");
			}
			dbg_button("Generate Layout Log", f);
			
			// render whichever item was picked
			var pick = target_list[pick_index];
			pick.inspectron.render();
		}
	}
}