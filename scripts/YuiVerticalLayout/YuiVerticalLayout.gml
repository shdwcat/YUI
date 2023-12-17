/// @description here
function YuiVerticalLayout(alignment, spacing, panel_size) : YuiLayoutBase() constructor {
	static is_live = false;
	
	self.alignment = alignment;
	self.spacing = spacing;	
	self.min_w = panel_size.min_w;
	
	// whether to use the full available width or just the max item width
	self.full_w = panel_size.w != "auto";
	
	// whether to resize items when our panel resizes
	self.fill = panel_size.fill;
	
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
		var yoffset = 0;
		var max_w = 0;
		
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
			
			var possible_size = getAvailableSizeForItem(i, yoffset);
			
			var item_size = item.arrange(possible_size, viewport_size);
			real_sizes[i] = item_size;
			if item_size {
				max_w = max(max_w, item_size.w);
			
				// only include the size if there is space for it
				if item_size.h > 0 {
					yoffset += item_size.h;
					yoffset += spacing;
				}
			}
			
			i++;
		}
		
		// subtract final spacing if we used any
		if yoffset > spacing {
			yoffset -= spacing
		}
		
		if is_flex_panel {
			var remaining_space = available_size.h - yoffset - (spacing * proportional_count);
			var i = 0; repeat count {
				var item = items[i];
				
				// skip normal-sized items
				if item.flex.is_normal {
					i++;
					continue;
				}
			
				// the exact height based on the the proportion of the remaining space
				var allotted_h = floor(item.flex.proportional / proportional_total * remaining_space);
			
				var possible_size = getAvailableSizeForItem(i, yoffset, allotted_h);
			
				//if trace {
				//	DEBUG_BREAK_YUI;
				//}
			
				var item_size = item.arrange(possible_size, viewport_size);
				item.resize(item.draw_size.w, allotted_h);
				real_sizes[i] = item_size;
				if item_size {
					max_w = max(max_w, item_size.w);
			
					// only include the size if there was space for it
					if item_size.h > 0 {
						yoffset += item_size.h;
						yoffset += spacing;
					}
				}
				
				i++;
			}
			
			// now we need to go through all items and move them around
			var new_y = available_size.y;
			var i = 0; repeat count {
				var item = items[i];
				var diff = new_y - item.y;
				item.move(0, diff);
				
				// TODO: wouldn't have to this real sizes thing if arrange also stored the layout size
				var real_size = real_sizes[i];
				if real_size {
					new_y += real_size.h + spacing;
				}
				i++;
			}
		}
		
		if trace {
			DEBUG_BREAK_YUI
		}
		
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: full_w ? available_size.w : max(min_w ?? 0, max_w),
			h: is_flex_panel ? available_size.h : yoffset, // flex uses the full space,
		};
		
		if alignment.h == "center" {
			i = 0; repeat count {
				var item_size = real_sizes[i];
				var offset = floor((draw_size.w - item_size.w) / 2);
				items[i++].move(offset, 0);
			}
		}
		else if alignment.h == "stretch" {
			i = 0; repeat count {
				var item = items[i++];
				item.resize(draw_size.w, item.draw_size.h);
			}
		}
		
		if !is_flex_panel && alignment.v == "center" {
			var offset = floor((available_size.h - yoffset) / 2);
			i = 0; repeat count {
				items[i++].move(0, offset);
			}
			draw_size.h = available_size.h;
		}
		
		return draw_size;
	}
	
	static resize = function(width, height) {		
		if fill {
			var count = array_length(items);
			var i = 0; repeat count {
				var item = items[i++];
				
				// NOTE: panel has already accounted for padding
				item.resize(width, item.draw_size.h);
			}
		}
	}
	
	static getAvailableSizeForItem = function(index, yoffset, allotted_h = undefined) {
		return {
			x: available_size.x,
			y: available_size.y + yoffset,
			w: available_size.w,
			h: allotted_h ?? available_size.h - yoffset,
		};
	}
}