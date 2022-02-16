/// @description here
function YuiVerticalLayout(alignment, padding, spacing) constructor {
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
		var yoffset = 0;
		var max_w = 0;
		
		var i = 0; repeat count {
						
			var item = items[i];
			var possible_size = getAvailableSizeForItem(i, yoffset);
			
			var item_size = item.arrange(possible_size);
			if item_size {
				max_w = max(max_w, item_size.w);
			
				// only include the size if there is space for it
				if (item_size.h > 0) {
					yoffset += item_size.h;
					yoffset += spacing;
				}
			}
			
			i++;
		}
		
		// subtract spacing if we used any
		if yoffset > spacing {
			yoffset -= spacing
		}
		
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: max_w,
			h: yoffset,
		};
		
		var used_size = {			
			x: available_size.x,
			y: available_size.y,
			w: max_w,
			h: yoffset,
		}			
		
		if alignment.h == "center" {
			i = 0; repeat count {
				yui_align_item(items[i++], alignment);
			}
			draw_size.x += (available_size.w - max_w) / 2;
			used_size.w = available_size.w;
		}	
		if alignment.v == "center" {
			var offset = (available_size.h - yoffset) / 2;
			i = 0; repeat count {
				items[i++].move(0, offset);
			}
			used_size.h = available_size.h;
		}
		
		return used_size;
	}
	
	static getAvailableSizeForItem = function(index, yoffset) {		
		return {
			x: available_size.x,
			y: available_size.y + yoffset,
			w: available_size.w,
			h: available_size.h - yoffset,
		};
	}
}