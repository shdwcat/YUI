/// @description here
function YuiCanvasLayout(alignment, spacing) constructor {
	static is_live = false;
	
	self.alignment = alignment;
	self.spacing = spacing;
	self.live_items = undefined;
	
	// elements may use this to calculate their own draw size
	self.draw_size = undefined;
	
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.available_size = available_size;
		self.viewport_size = viewport_size;
		
		// init live items only once
		if live_items == undefined {
			
			live_items = array_create(array_length(items));
			
			var i = 0; repeat array_length(items) {
				var item = items[i];
				var canvas = item.canvas;
				
				if canvas.is_bound {
					is_live = true;
					live_items[i] = item.canvas;
				}
				
				i++;
			}
		}
	}
	
	static getLiveItemValues = function(data, prev) {
		var is_changed = prev == undefined;
		
		var results = array_create(array_length(live_items), undefined);
		
		var i = 0; repeat array_length(live_items) {
			var canvas = live_items[i];
			
			// only live item indexes will have a canvas value
			if canvas {
				var values = {
					left: yui_resolve_binding(canvas.left, data),
					top: yui_resolve_binding(canvas.top, data),
					right: yui_resolve_binding(canvas.right, data),
					bottom: yui_resolve_binding(canvas.bottom, data),
				};
			
				// if we have previous values, check if any of them are different
				if prev {
					var old_values = prev.liveItemValues[i];
				
					if old_values.left != values.left
					|| old_values.top != values.top
					|| old_values.right != values.right
					|| old_values.bottom != values.bottom {
						is_changed = true;
					}
				}
			
				results[i] = values;
			}
			i++;
		}
		
		if !is_changed {
			return true;
		}
		
		return results;
	}
	
	static arrange = function(bound_values) {
		
		var i = 0; repeat array_length(items) {
			
			var item = items[i];
			var canvas = item.canvas;
			
			// if the item is live, get the live value instead
			if canvas.is_bound {
				var live_values = bound_values.liveItemValues[i];
				var left = live_values.left;
				var top = live_values.top;
				var right = live_values.right;
				var bottom = live_values.bottom;
			}
			else {
				var left = canvas.left;
				var top = canvas.top;
				var right = canvas.right;
				var bottom = canvas.bottom;
			}
			
			// fit the item within the bounds defined by the canvas properties
			if canvas.normalized {
				// normalized means position units are fractions of the available size
				var possible_size = {
					x: available_size.x + (left * available_size.w),
					y: available_size.y + (top * available_size.h),
					w: available_size.w * (1 - (left + right)),
					h: available_size.h * (1 - (top + bottom)),
				};
				right = right * available_size.w;
				bottom = bottom * available_size.h;
			}
			else {
				var possible_size = {
					x: available_size.x + left,
					y: available_size.y + top,
					w: available_size.w - (left + right),
					h: available_size.h - (top + bottom),
				};
			}
			
			var item_size = item.arrange(possible_size, viewport_size);
			
			// do post-arrange alignment
			var xoffset = 0;
			var yoffset = 0;
			if item_size {
				if canvas.right_aligned {
					xoffset = available_size.w - item_size.w - right;
				}
				if canvas.bottom_aligned {
					yoffset = available_size.h - item_size.h - bottom;
				}
				if canvas.center_h {
					xoffset = floor(available_size.w / 2 - (item_size.w / 2));
				}
				if canvas.center_v {
					yoffset = floor(available_size.h / 2 - (item_size.h / 2));
				}
			}
			
			if xoffset != 0 || yoffset != 0 {
				item.move(xoffset, yoffset);
			}
			
			i++;
		}
		
		// canvas always fills the available space
		draw_size = {
			x: available_size.x,
			y: available_size.y,
			w: available_size.w,
			h: available_size.h,
		};
		
		return draw_size;
	}
}

function YuiCanvasPosition(canvas_position = {}, resources, slot_values, item_id) constructor {
	self.item_id = item_id;
	
	var center = canvas_position[$ "center"];
	center_h = center == true || center == "h";
	center_v = center == true || center == "v";
	
	normalized = canvas_position[$ "normalized"] == true;
	
	left = yui_bind(canvas_position[$ "left"], resources, slot_values);
	top = yui_bind(canvas_position[$ "top"], resources, slot_values);
	right = yui_bind(canvas_position[$ "right"], resources, slot_values);
	bottom = yui_bind(canvas_position[$ "bottom"], resources, slot_values);
	
	is_bound = yui_is_live_binding(left)
		|| yui_is_live_binding(top)
		|| yui_is_live_binding(right)
		|| yui_is_live_binding(bottom);
	
	right_aligned = right != undefined && left == undefined;
	bottom_aligned = bottom != undefined && top == undefined;
	
	left ??= 0;
	top ??= 0;
	right ??= 0;
	bottom ??= 0;
}