/// @description here
function YuiOverlayLayout(alignment, spacing, panel_size) : YuiLayoutBase(alignment, spacing) constructor {
	static is_live = false;
	
	self.min_w = panel_size.min_w;
	self.min_h = panel_size.min_h;
	
	// whether the panel should stretch to fill the available space
	self.stretch_w = panel_size.w == "stretch";
	self.stretch_h = panel_size.h == "stretch";
	
	// whether content should be resized to fill the panel draw size
	self.fill = panel_size.fill;
		
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.available_size = available_size;
		self.viewport_size = viewport_size;
	}
	
	static arrange = function() {
		// track the biggest width and height
		var max_w = 0;
		var max_h = 0;
		
		var count = array_length(items);
		var real_sizes = array_create(count);
		
		var i = 0; repeat count {
			var item = items[i];
			
			var item_size = item.arrange(available_size, viewport_size);
			real_sizes[i] = item_size;
			if item_size {
				max_w = max(max_w, item_size.w);
				max_h = max(max_h, item_size.h);
			}
			
			i++;
		}
		
		if trace
			mx_break();
			
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: stretch_w ? available_size.w : max(min_w ?? 0, max_w),
			h: stretch_h ? available_size.h : max(min_h ?? 0, max_h),
		};
		
		// handle centering
		var i = 0; repeat count {
			var item_size = real_sizes[i];
			
			var xoffset = alignment.h == "center"
				? floor((draw_size.w - item_size.w) / 2)
				: 0;
			
			var yoffset = alignment.v == "center"
				? floor((draw_size.h - item_size.h) / 2)
				: 0;
				
			if xoffset > 0 or yoffset > 0
				items[i++].move(xoffset, yoffset);
		}
		
		// handle fill	
		if fill {
			resize(draw_size.w, draw_size.h);
		}
		
		return draw_size;
	}
	
	static resize = function(width, height) {		
		if fill {
			var count = array_length(items);
			var i = 0; repeat count {
				var item = items[i++];
				
				// NOTE: panel has already accounted for padding
				item.resize(width, height);
			}
		}
	}
}