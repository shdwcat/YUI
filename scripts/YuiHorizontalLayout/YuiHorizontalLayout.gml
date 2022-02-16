/// @description here
function YuiHorizontalLayout(alignment, padding, spacing) constructor {
	static is_live = false;
	
	self.alignment = alignment;
	self.padding = padding;
	self.spacing = spacing;
	
	static init = function(items, available_size) {
		self.items = items;
		self.available_size = available_size;
	}
	
	static arrange = function() {
		var count = array_length(items);
		var xoffset = 0;
		var max_h = 0;
		
		var i = 0; repeat count {
						
			var item = items[i];
			var possible_size = getAvailableSizeForItem(i, xoffset);
			
			var item_size = item.arrange(possible_size);
			if item_size {
				max_h = max(max_h, item_size.h);
			
				// only include the size if there is space for it
				if (item_size.w > 0) {
					xoffset += item_size.w;
					xoffset += spacing;
				}
			}
			
			i++;
		}
		
		// subtract spacing if we used any
		if xoffset > spacing {
			xoffset -= spacing
		}
		
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: xoffset,
			h: max_h,
		};
		
		var used_size = {			
			x: available_size.x,
			y: available_size.y,
			w: xoffset,
			h: max_h,
		}			
		
		if alignment.h == "center" {
			var offset = (available_size.w - xoffset) / 2;
			i = 0; repeat count {
				items[i++].move(offset, 0);
			}
			used_size.w = available_size.w;
		}	
		if alignment.v == "center" {
			i = 0; repeat count {
				yui_align_item(items[i++], alignment);
			}
			draw_size.y += (available_size.h - max_h) / 2;
			used_size.h = available_size.h;
		}
		
		return used_size;
	}
	
	static getAvailableSizeForItem = function(index, xoffset) {		
		return {
			x: available_size.x + xoffset,
			y: available_size.y,
			w: available_size.w - xoffset,
			h: available_size.h,
		};
	}
}