/// @description here
function YuiCanvasLayout(alignment, padding, spacing) constructor {
	
	self.alignment = alignment;
	self.padding = padding;
	self.spacing = spacing;
	
	// elements may use this to calculate their own draw size
	self.draw_size = undefined;
	
	static init = function(items, available_size) {
		self.items = items;
		self.available_size = available_size;
	}
	
	static arrange = function() {
		
		var i = 0; repeat array_length(items) {
			
			var item = items[i];
			var canvas = item.canvas;
			
			// fit the item within the bounds defined by the canvas properties
			var possible_size = {
				x: available_size.x + canvas.left,
				y: available_size.y + canvas.top,
				w: available_size.w - (canvas.left + canvas.right),
				h: available_size.h - (canvas.top + canvas.bottom),
			};
			
			var item_size = item.arrange(possible_size);
			
			// do post-arrange alignment
			var xoffset = 0;
			var yoffset = 0;
			if canvas.right_aligned {
				xoffset = available_size.w - item_size.w - canvas.right;
			}
			if canvas.bottom_aligned {
				yoffset = available_size.h - item_size.h - canvas.bottom;
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

function YuiCanvasPosition(canvas_position = {}) constructor {
	var center = canvas_position[$ "center"];
	center_h = center == true || center == "h";
	center_v = center == true || center == "v";
	
	left = canvas_position[$ "left"];
	top = canvas_position[$ "top"];
	right = canvas_position[$ "right"];
	bottom = canvas_position[$ "bottom"];
	
	right_aligned = right != undefined && left == undefined;
	bottom_aligned = bottom != undefined && top == undefined;
	
	if center_h && (left != undefined || right != undefined) {
		throw "Cannot center horizontally AND left/right align";
	}
	if center_v && (top != undefined || bottom != undefined) {
		throw "Cannot center vertically AND top/bottom align";
	}
	
	if left == undefined left = 0;
	if top == undefined top = 0;
	if right == undefined right = 0;
	if bottom == undefined bottom = 0;			
}