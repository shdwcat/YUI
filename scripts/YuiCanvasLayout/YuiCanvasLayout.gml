/// @description here
function YuiCanvasLayout(alignment, padding, spacing) constructor {
	static is_live = false;
	
	self.alignment = alignment;
	self.padding = padding;
	self.spacing = spacing;
	
	// elements may use this to calculate their own draw size
	self.draw_size = undefined;
	
	static init = function(items, available_size, viewport_size, panel_props) {
		self.items = items;
		self.available_size = available_size;
		self.viewport_size = viewport_size;
		
		if !is_live {
			var i = 0; repeat array_length(items) {
				var item = items[i++];
				var canvas = item.canvas;
				
				if canvas.is_bound {
					is_live = true;
					break;
				}
			}
		}	
	}
	
	static arrange = function(data_context) {
		
		var i = 0; repeat array_length(items) {
			
			var item = items[i++];
			var canvas = item.canvas;
			
			var left = yui_resolve_binding(canvas.left, data_context);
			var top = yui_resolve_binding(canvas.top, data_context);
			var right = yui_resolve_binding(canvas.right, data_context);
			var bottom = yui_resolve_binding(canvas.bottom, data_context);
			
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
			
			var is_visible = !viewport_size || rectangle_in_rectangle(
				possible_size.x, possible_size.y,
				possible_size.x + possible_size.w, possible_size.y + possible_size.h,
				viewport_size.x, viewport_size.y,
				viewport_size.x + viewport_size.w, viewport_size.y + viewport_size.h)
				
			item.hidden = !is_visible;
			
			var item_size = item.arrange(possible_size, viewport_size);
			
			// do post-arrange alignment
			var xoffset = 0;
			var yoffset = 0;
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
			
			if xoffset != 0 || yoffset != 0 {
				item.move(xoffset, yoffset);
			}
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

function YuiCanvasPosition(canvas_position = {}, resources, slot_values) constructor {
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
	
	if center_h && (left != undefined || right != undefined) {
		throw "Cannot center horizontally AND left/right align";
	}
	if center_v && (top != undefined || bottom != undefined) {
		throw "Cannot center vertically AND top/bottom align";
	}
	
	left ??= 0;
	top ??= 0;
	right ??= 0;
	bottom ??= 0;			
}