/// @desc manages a debug overlay for inspecting YUI items
function YuiInspector() constructor {
		
	target = undefined;
	target_list = undefined;
	debug_pointer = undefined;
	
	min_w = 500;
	min_h = 300;
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
			
			var window_w = window_get_width();
			var window_h = window_get_height();
			var max_x = window_w - w;
			var max_y = window_h - h;
			
			var target_left = target.x;			
			var target_top = target.y;
			var target_w = target.draw_size.w;
			var target_h = target.draw_size.h;
			
			var target_right = target_left + target_w;
			var target_bottom = target_top + target_h;
			
			var position = "right";
			var desired_x = target_right + 5;
			var desired_y = target_top;
			var desired_w = w;
			var desired_h = h;
			
			var free_w = window_w - desired_x;
			
			if free_w < desired_w {
				if free_w > min_w {
					desired_w = free_w;
				}
				else if target_left + min_w < window_w {
					// resposition down
					yui_log("repositioning down (from width)");
					position = "down";
					desired_x = target_left;
					desired_y = target_bottom + 5;
				}
				else {
					// resposition left
					yui_log("repositioning left (from width)");
					position = "left";
					desired_x = target_left - w;
					desired_y = target_top;
				}
			}
			
			var free_h = window_h - desired_y;
			if free_h < h {
				if free_h > min_h {
					desired_h = free_h;
				}
				else if position == "right" {
					// if we had room to the right, just move the view up on screen
					desired_y = window_h - min_h;
					desired_h = min_h;
				}
				else {
					// resposition left
					yui_log("repositioning left (from height)");
					position = "left";
					desired_x = target_left - w;
					desired_y = target_top;
					
					// check height again
					free_h = window_h - desired_y;
					if free_h < h {
						if free_h > min_h {
							desired_h = free_h;
						}
						else {
							// just move the view up on screen
							desired_y = window_h - min_h;
							desired_h = min_h;
						}
					}
				}
			}
			
			// if off screen left or above, reposition bottom right
			if desired_x < 0 || desired_y < 0 {
				yui_log("positioning bottom right as last resort");
				position = "bottom_right";
				desired_x = max_x;
				desired_y = max_y;
				desired_w = w;
				desired_h = h;
			}
		
			debug_pointer = dbg_view(
				$"YUI - {target._id}", true,
				desired_x, desired_y, desired_w, desired_h);
			
			dbg_section("General");
			dbg_text($"Target: x: {target.x}, y: {target.y}");
			dbg_text($"Window: w: {window_w}, h: {window_h}");
			dbg_text($"Debug View: x: {desired_x}, y: {desired_y}, w: {desired_w}, h: {desired_h}");
						
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