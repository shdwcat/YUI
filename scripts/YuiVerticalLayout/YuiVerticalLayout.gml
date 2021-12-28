
function YuiVerticalLayout() : YuiLayoutBase() constructor {
	alignment = { vertical: "top", horizontal: "left" };
	maximum_width = 0;

	static update = function(item_render_size, spacing) {
		// modify the current draw rect by the space that was used
		current_draw_rect.y += item_render_size.h + spacing;
		current_draw_rect.h -= item_render_size.h + spacing;
		
		maximum_width = max(maximum_width, item_render_size.w);
		
		// account for that space in the final size
		draw_size.h += item_render_size.h + spacing;
		
		if current_draw_rect.h <= 0 {
			//yui_log("layout broken");
			return false;
		}
		
		return true;
	};
	
	static complete = function(children, spacing) {
		
		draw_size.h -= spacing; // we need to trim off the spacing for the last item
				
		switch (alignment.horizontal) {
			case "left":
			case "right":
				draw_size.w = maximum_width + padding.w;
				break;
			case "stretch":
				draw_size.w = draw_rect.w;
				break;
				
			case "center":			
				draw_size.w = draw_rect.w;
				
				// offset all the children by the difference between their width and half the panel width
				var count = array_length(children);
				for (var i = 0; i < count; ++i) {
					var child = children[i];
					if child {
						var xoffset = draw_size.w / 2 - child.w / 2;
						child.finalize(xoffset, 0);
					}
				}
				break;
		}
		
		switch (alignment.vertical) {
			case "top":
				break;
			case "bottom":
			
				// offset all the children by the difference between their height and the panel height
				var count = array_length(children);
				for (var i = 0; i < count; ++i) {
					var child = children[i];
					if child {
						var yoffset = draw_size.h - child.h;
						child.finalize(0, yoffset);
					}
				}
				
				break;
				
			case "center":			
				draw_size.h = draw_rect.h;
			
				// offset all the children by the difference between their height and half the panel height
				var count = array_length(children);
				for (var i = 0; i < count; ++i) {
					var child = children[i];
					if child {
						var yoffset = draw_size.h / 2 - child.h;
						child.finalize(0, yoffset);
					}
				}
				
				break;
			case "stretch":
				draw_size.h = draw_rect.h;
				break;
		}
		
		if size.is_exact_size {
			if is_numeric(size.w) draw_size.w = size.w;
			if is_numeric(size.h) draw_size.h = size.h;
		}
		
		return draw_size;
	};
}