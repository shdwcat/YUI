/// @description here
function YuiVerticalLayout(alignment, spacing) constructor {
	static is_live = false;
	
	self.alignment = alignment;
	self.spacing = spacing;
	
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.available_size = available_size;
		self.viewport_size = viewport_size;
	}
	
	static arrange = function() {
		var count = array_length(items);
		var yoffset = 0;
		var max_w = 0;
		
		var i = 0; repeat count {
						
			var item = items[i];
			var possible_size = getAvailableSizeForItem(i, yoffset);
			
			var item_size = item.arrange(possible_size, viewport_size);
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
		
		if alignment.h == "center" {
			var offset = (available_size.w - max_w) / 2
			i = 0; repeat count {
				items[i++].move(offset, 0);
			}
			draw_size.w = available_size.w;
		}
		else if alignment.h == "stretch" {
			i = 0; repeat count {
				var item = items[i++];
				item.resize(draw_size.w, item.draw_size.h);
			}
		}
		
		if alignment.v == "center" {
			var offset = (available_size.h - yoffset) / 2;
			i = 0; repeat count {
				items[i++].move(0, offset);
			}
			draw_size.h = available_size.h;
		}
		
		return draw_size;
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