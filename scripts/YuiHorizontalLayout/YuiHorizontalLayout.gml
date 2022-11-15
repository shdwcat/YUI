/// @description here
function YuiHorizontalLayout(alignment, spacing) constructor {
	static is_live = false;
	
	self.alignment = alignment;
	self.spacing = spacing;
	
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.available_size = available_size;
		self.viewport_size = viewport_size;
		proportional_count = 0;
		proportional_total = 0;
		
		var count = array_length(items);
		var i = 0; repeat count {
			var item = items[i];
			var flex = item.flex;
			if !flex.is_normal {
				proportional_count++;
				proportional_total += flex.proportional;
			}
			i++;
		}
		
		self.is_flex_panel = proportional_total != 0;
	}
	
	static arrange = function() {
		var xoffset = 0;
		var max_h = 0;
		
		var count = array_length(items);
		var real_sizes = array_create(count);
		
		var i = 0; repeat count {
			var item = items[i];
			
			// skip proportional items
			if !item.flex.is_normal {
				i++;
				continue;
			}
			
			//if trace {
			//	DEBUG_BREAK_YUI;
			//}
			
			var possible_size = getAvailableSizeForItem(i, xoffset);
			
			var item_size = item.arrange(possible_size, viewport_size);
			real_sizes[i] = item_size;
			if item_size {
				max_h = max(max_h, item_size.h);
			
				// only include the size if there is space for it
				if item_size.w > 0 {
					xoffset += item_size.w;
					xoffset += spacing;
				}
			}
			
			i++;
		}
		
		// subtract final spacing if we used any
		if xoffset > spacing {
			xoffset -= spacing
		}
		
		if is_flex_panel {
			var remaining_space = available_size.w - xoffset  - (spacing * proportional_count);
			var i = 0; repeat count {
				var item = items[i];
				
				// skip normal-sized items
				if item.flex.is_normal {
					i++;
					continue;
				}
			
				// the exact width based on the the proportion of the remaining space
				var allotted_w = floor(item.flex.proportional / proportional_total * remaining_space);
			
				var possible_size = getAvailableSizeForItem(i, xoffset, allotted_w);
			
				//if trace {
				//	DEBUG_BREAK_YUI;
				//}
			
				var item_size = item.arrange(possible_size, viewport_size);
				item.resize(allotted_w, item.draw_size.h);
				real_sizes[i] = item_size;
				if item_size {
					max_h = max(max_h, item_size.h);
			
					// only include the size if there was space for it
					if item_size.w > 0 {
						xoffset += item_size.w;
						xoffset += spacing;
					}
				}
				
				i++;
			}
			
			// now we need to go through all items and move them around
			var new_x = available_size.x;
			var i = 0; repeat count {
				var item = items[i];
				var diff = new_x - item.x;
				item.move(diff, 0);
				
				// TODO: wouldn't have to this real sizes thing if arrange also stored the layout size
				var real_size = real_sizes[i];
				if real_size {
					new_x += real_size.w + spacing;
				}
				i++;
			}
		}
		
		//if trace {
		//	DEBUG_BREAK_YUI;
		//}
		
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: is_flex_panel ? available_size.w : xoffset, // flex uses the full space
			h: max_h,
		};

		if !is_flex_panel && alignment.h == "center" {
			var offset = floor((available_size.w - xoffset) / 2);
			i = 0; repeat count {
				items[i++].move(offset, 0);
			}
			draw_size.w = available_size.w;
		}
		if alignment.v == "center" {
			i = 0; repeat count {
				var item_size = real_sizes[i];
				var offset = floor((available_size.h - item_size.h) / 2);
				items[i++].move(0, offset);
			}
			draw_size.h = available_size.h;
		}
		else if alignment.v == "stretch" {
			i = 0; repeat count {
				var item = items[i++];
				item.resize(item.draw_size.w, draw_size.h);
			}
		}
		
		return draw_size;
	}
	
	static getAvailableSizeForItem = function(index, xoffset, allotted_w = undefined) {
		return {
			x: available_size.x + xoffset,
			y: available_size.y,
			w: allotted_w ?? available_size.w - xoffset,
			h: available_size.h,
		};
	}
}