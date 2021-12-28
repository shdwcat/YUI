function YuiHorizontalLayout() : YuiLayoutBase() constructor {
	alignment = { vertical: "top", horizontal: "left" };
	maximum_height = 0;

	static update = function(item_render_size, spacing) {
		// modify the current draw rect by the space that was used
		current_draw_rect.x += item_render_size.w + spacing;
		current_draw_rect.w -= item_render_size.w + spacing;
		
		maximum_height = max(maximum_height, item_render_size.h);
		
		// account for that space in the final size
		draw_size.w += item_render_size.w + spacing;
		
		if current_draw_rect.w <= 0 {
			//yui_log("layout broken");
			return false;
		}
		
		return true;
	};
	
	static complete = function(children, spacing) {
		draw_size.w -= spacing; // we need to trim off the spacing for the last item
		
		switch (alignment.vertical) {
			case "top":
				draw_size.h = maximum_height + padding.h;
				break;
			case "bottom":
				draw_size.h = maximum_height + padding.h;
								
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
			case "stretch":
				draw_size.h = draw_rect.h;
				break;
		}
		
		switch (alignment.horizontal) {
			case "left":
				break;
			case "right":
				//draw_size.w = draw_rect.w - padding.w;
			
				// offset all the children by the difference between their width and the panel width
				var used_width = 0;
				var count = array_length(children);
				for (var i = count - 1; i >= 0; --i) {
					var child = children[i];
					if child {
						var xoffset = draw_rect.w - draw_size.w;
						child.finalize(xoffset, 0);
						used_width += child.w;
					}
				}
			
				break;
			case "stretch":
				draw_size.w = draw_rect.w;
				break;
		}		
		
		if size.is_exact_size {
			if is_numeric(size.w) draw_size.w = size.w;
			if is_numeric(size.h) draw_size.h = size.h;
		}
		
		return draw_size;
	};
}